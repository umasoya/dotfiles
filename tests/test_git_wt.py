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
            root = Path(tmp)
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


if __name__ == "__main__":
    unittest.main()
