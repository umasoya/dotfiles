"""Test installation orchestration using fake tools, downloads and a temporary tty."""
import fcntl
import json
import os
from pathlib import Path
import pty
import subprocess
import tempfile
import termios
import unittest

ROOT = Path(__file__).resolve().parents[1]


class ToolSetupTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-tools-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / "home with spaces"
        self.home.mkdir()
        self.bin = self.home / "bin"
        self.bin.mkdir()
        self.checkout = self.home / "checkout"
        (self.checkout / "sh").mkdir(parents=True)
        # Use isolated initialization scripts, never those of the execution host.
        (self.checkout / "sh/nix.sh").write_text(
            'export PATH="$HOME/.nix-profile/bin:$PATH"\n')
        (self.checkout / "sh/brew.sh").write_text(
            'export PATH="$HOME/testbrew/bin:$PATH"\n')
        self.env = {"HOME": str(self.home), "PATH": f"{self.bin}:/usr/bin:/bin",
                    "TMPDIR": self.temp.name}
        self.write_tool("uname", '#!/bin/sh\nprintf "%s\\n" "${TEST_OS:-Linux}"\n')
        self.nix_script = '''#!/usr/bin/python3
import json
import os
from pathlib import Path
import sys
args = sys.argv[1:]
with open(Path(os.environ["HOME"]) / "calls", "a") as log:
    log.write(json.dumps(["nix", *args]) + "\\n")
if "install" in args:
    if os.environ.get("NIX_FAIL"):
        sys.exit(9)
    Path(args[args.index("--profile") + 1]).mkdir(parents=True)
'''
        self.brew_script = '''#!/usr/bin/python3
import json
import os
from pathlib import Path
import sys
with open(Path(os.environ["HOME"]) / "calls", "a") as log:
    log.write(json.dumps(["brew", *sys.argv[1:]]) + "\\n")
sys.exit(int(os.environ.get("BREW_STATUS", "0")))
'''
        (self.home / "mock-nix").write_text(self.nix_script)
        (self.home / "mock-brew").write_text(self.brew_script)
        self.write_tool("curl", '''#!/usr/bin/python3
import json
import os
from pathlib import Path
import sys
args = sys.argv[1:]
with open(Path(os.environ["HOME"]) / "calls", "a") as log:
    log.write(json.dumps(["curl", *args]) + "\\n")
if os.environ.get("CURL_FAIL"):
    sys.exit(22)
kind = "nix" if "https://nixos.org/nix/install" in args else "brew"
target = '.nix-profile/bin' if kind == 'nix' else 'testbrew/bin'
Path(args[args.index("-o") + 1]).write_text(
    '#!/bin/bash\\nset -eu\\n'
    'test -t 0\\n'
    'printf "installer\\\\n" >> "$HOME/installer-calls"\\n'
    f'mkdir -p "$HOME/{target}"\\n'
    f'cp "$HOME/mock-{kind}" "$HOME/{target}/{kind}"\\n'
    f'chmod +x "$HOME/{target}/{kind}"\\n')
''')

    def write_tool(self, name, script):
        path = self.bin / name
        path.write_text(script)
        path.chmod(0o755)

    def run_setup(self, success=True, terminal=False):
        kwargs = {}
        if terminal:
            master, slave = pty.openpty()
            self.addCleanup(os.close, master)
            self.addCleanup(os.close, slave)

            def attach_terminal():
                os.setsid()
                fcntl.ioctl(slave, termios.TIOCSCTTY, 0)

            kwargs.update(preexec_fn=attach_terminal, pass_fds=(slave,))
        result = subprocess.run(
            ["bash", str(ROOT / "sh/setup-tools.sh"), str(self.checkout)],
            env=self.env, stdin=subprocess.DEVNULL, capture_output=True, text=True,
            **kwargs,
        )
        if success:
            self.assertEqual(result.returncode, 0, result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0)
        return result

    def calls(self):
        path = self.home / "calls"
        return [json.loads(line) for line in path.read_text().splitlines()] if path.exists() else []

    def test_linux_installs_profile_once_without_homebrew(self):
        self.write_tool("nix", self.nix_script)
        self.env["XDG_STATE_HOME"] = str(self.home / "custom state")
        self.run_setup()
        self.run_setup()
        installs = [call for call in self.calls() if "install" in call]
        self.assertEqual(len(installs), 1)
        self.assertIn("--no-update-lock-file", installs[0])
        self.assertIn(f"{self.checkout}#default", installs[0])
        self.assertIn(str(self.home / "custom state/nix/profiles/dotfiles"), installs[0])
        self.assertFalse(any(call[0] in ("curl", "brew") for call in self.calls()))

    def test_macos_installs_only_missing_apps_without_upgrade(self):
        self.write_tool("nix", self.nix_script)
        self.write_tool("brew", self.brew_script)
        self.env["TEST_OS"] = "Darwin"
        self.run_setup()
        self.assertIn(["brew", "bundle", f"--file={self.checkout}/brew/Brewfile",
                       "--no-upgrade"], self.calls())
        self.assertFalse(any(call[0] == "curl" for call in self.calls()))

    def test_first_install_uses_downloaded_scripts_with_terminal(self):
        self.env["TEST_OS"] = "Darwin"
        self.run_setup(terminal=True)
        calls = self.calls()
        self.assertEqual(len([call for call in calls if call[0] == "curl"]), 2)
        self.assertEqual((self.home / "installer-calls").read_text(), "installer\ninstaller\n")
        self.assertTrue(any(call[0] == "brew" for call in calls))
        self.assertEqual(list(Path(self.temp.name).glob("dotfiles-installer.*")), [])
        self.run_setup()
        self.assertEqual(len([call for call in self.calls() if call[0] == "curl"]), 2)

    def test_nix_outside_path_is_reused(self):
        target = self.home / ".nix-profile/bin"
        target.mkdir(parents=True)
        nix = target / "nix"
        nix.write_text(self.nix_script)
        nix.chmod(0o755)
        self.run_setup()
        self.assertFalse(any(call[0] == "curl" for call in self.calls()))

    def test_missing_terminal_stops_before_downloading(self):
        self.assertIn("terminal is required", self.run_setup(success=False).stderr)
        self.assertEqual(self.calls(), [])

    def test_failed_nix_install_stops_before_brew_and_can_resume(self):
        self.write_tool("nix", self.nix_script)
        self.write_tool("brew", self.brew_script)
        self.env.update(TEST_OS="Darwin", NIX_FAIL="1")
        self.assertEqual(self.run_setup(success=False).returncode, 9)
        self.assertFalse(any(call[0] == "brew" for call in self.calls()))
        del self.env["NIX_FAIL"]
        self.run_setup()
        self.assertTrue(any(call[0] == "brew" for call in self.calls()))

    def test_failed_download_does_not_run_installer(self):
        self.env["CURL_FAIL"] = "1"
        self.run_setup(success=False, terminal=True)
        self.assertFalse((self.home / "installer-calls").exists())
        self.assertEqual(list(Path(self.temp.name).glob("dotfiles-installer.*")), [])

    def test_brew_failure_is_propagated(self):
        self.write_tool("nix", self.nix_script)
        self.write_tool("brew", self.brew_script)
        self.env.update(TEST_OS="Darwin", BREW_STATUS="6")
        self.assertEqual(self.run_setup(success=False).returncode, 6)


if __name__ == "__main__":
    unittest.main()
