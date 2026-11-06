import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "bin" / "git-wt"


class GitWtTests(unittest.TestCase):
    def test_arguments_and_validation(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp).resolve()
            repo = root / "repo with spaces"
            repo.mkdir()
            env = dict(os.environ, GIT_CONFIG_NOSYSTEM="1",
                       GIT_CONFIG_GLOBAL=os.devnull)

            def git(*args):
                return subprocess.run(["git", "-C", str(repo), *args],
                                      env=env, check=True, capture_output=True)

            git("init")
            git("-c", "user.name=Test", "-c", "user.email=test@example.invalid",
                "-c", "commit.gpgsign=false", "commit", "--allow-empty", "-m", "test")
            git("branch", "existing")
            mock_bin = root / "bin"
            mock_bin.mkdir()
            herdr = mock_bin / "herdr"
            herdr.write_text('#!/usr/bin/env python3\nimport json, sys\n'
                             'from pathlib import Path\n'
                             'Path(__file__).with_name("args.json").write_text(json.dumps(sys.argv[1:]))\n'
                             'print(json.dumps({"result": {"worktree": '
                             '{"branch": sys.argv[sys.argv.index("--branch") + 1], '
                             '"path": "/worktrees/repo with spaces/test"}}}))\n')
            herdr.chmod(0o755)
            env["PATH"] = str(mock_bin) + os.pathsep + env["PATH"]
            subdir = repo / "subdir"
            subdir.mkdir()

            def run(*args):
                return subprocess.run([str(SCRIPT), *args], cwd=subdir,
                                      env=env, text=True, capture_output=True)

            for branch, base in (("feat/new", []), ("feat/base", ["HEAD"]),
                                 ("existing", [])):
                result = run(branch, *base)
                self.assertEqual(result.returncode, 0, result.stderr)
                expected = ["worktree", "create", "--cwd", str(repo),
                            "--branch", branch, "--focus"]
                if base:
                    expected += ["--base", "HEAD"]
                self.assertEqual(json.loads((mock_bin / "args.json").read_text()), expected)
                self.assertEqual(result.stdout,
                                 f"Worktreeを作成しました\n  ブランチ: {branch}\n"
                                 "  作成先:   /worktrees/repo with spaces/test\n")

            for args in ([], ["bad..branch"], ["feat/new", "missing-ref"],
                         ["existing", "HEAD"], ["a", "b", "c"]):
                result = run(*args)
                self.assertNotEqual(result.returncode, 0)
                self.assertNotIn('"worktree"', result.stdout)
            self.assertEqual(run("--help").returncode, 0)

            herdr.write_text('#!/usr/bin/env bash\necho "server unavailable" >&2\n'
                             'echo \'{"error":"failed"}\'\nexit 7\n')
            result = run("feat/failure")
            self.assertEqual(result.returncode, 7)
            self.assertIn("server unavailable", result.stderr)
            self.assertIn('{"error":"failed"}', result.stderr)
            self.assertEqual(result.stdout, "")

            herdr.write_text('#!/usr/bin/env bash\necho \'{"new_schema":true}\'\n')
            result = run("feat/future")
            self.assertEqual(result.returncode, 0)
            self.assertEqual(result.stdout, '{"new_schema":true}\n')

            checkout = root / "linked checkout"
            git("worktree", "add", "-b", "cleanup", str(checkout))
            listing = mock_bin / "listing.json"
            calls = mock_bin / "remove.json"
            herdr.write_text(
                '#!/usr/bin/env python3\nimport json, sys\nfrom pathlib import Path\n'
                'root = Path(__file__).parent\n'
                'if sys.argv[1:3] == ["worktree", "list"]:\n'
                '    print((root / "listing.json").read_text())\n'
                'else:\n'
                '    (root / "remove.json").write_text(json.dumps(sys.argv[1:]))\n'
                '    print("{}")\n')

            def set_listing(branch="cleanup", linked=True, workspace=None):
                listing.write_text(json.dumps({"result": {"worktrees": [{
                    "branch": branch, "path": str(checkout),
                    "is_linked_worktree": linked, "open_workspace_id": workspace,
                }]}}))

            set_listing(workspace="w99")
            dirty = checkout / "untracked.txt"
            dirty.write_text("keep me")
            self.assertNotEqual(run("--remove", "cleanup").returncode, 0)
            self.assertFalse(calls.exists())
            dirty.unlink()
            result = run("--remove", "cleanup")
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(json.loads(calls.read_text()),
                             ["worktree", "remove", "--workspace", "w99"])
            self.assertIn("Worktreeを削除しました", result.stdout)
            calls.unlink()

            set_listing()
            result = subprocess.run([str(SCRIPT), "--remove", "cleanup"],
                                    cwd=checkout, env=env, capture_output=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertTrue(checkout.exists())

            git("worktree", "lock", str(checkout))
            self.assertNotEqual(run("--remove", "cleanup").returncode, 0)
            self.assertTrue(checkout.exists())
            git("worktree", "unlock", str(checkout))
            result = run("--remove", "cleanup")
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertFalse(checkout.exists())
            git("show-ref", "--verify", "refs/heads/cleanup")

            set_listing(linked=False)
            self.assertNotEqual(run("--remove", "cleanup").returncode, 0)
            self.assertNotEqual(run("--remove", "unknown").returncode, 0)
            self.assertNotEqual(run("--remove").returncode, 0)
            self.assertFalse(calls.exists())


if __name__ == "__main__":
    unittest.main()
