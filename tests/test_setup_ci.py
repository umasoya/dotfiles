"""Exercise the workflow's actual change filter and required-check decision."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import textwrap
import unittest

WORKFLOW = (Path(__file__).resolve().parents[1] /
            ".github/workflows/setup-test.yml").read_text()


class RequiredSetupCheckTests(unittest.TestCase):
    @unittest.skipUnless(shutil.which("node"), "Node.js is required for the Actions filter")
    def test_change_filter(self):
        script = textwrap.dedent(WORKFLOW.split("          script: |\n", 1)[1]
                                 .split("\n  test:", 1)[0])
        cases = [
            ([{"filename": "README.md"}], 1, False),
            ([{"filename": "init.sh"}], 1, True),
            ([{"filename": ".zshrc"}], 1, True),
            ([{"filename": "nix/packages.nix"}], 1, True),
            ([{"filename": ".githooks/pre-commit"}], 1, True),
            ([{"filename": "bin/git-wt"}], 1, True),
            ([{"filename": ".github/workflows/setup-test.yml"}], 1, True),
            ([{"filename": ".github/scripts/test-setup.py"}], 1, True),
            ([{"filename": "docs/old-init.sh", "previous_filename": "init.sh"}], 1, True),
            ([{"filename": "README.md"}], 2, "error"),
        ]
        for files, count, expected in cases:
            with self.subTest(files=files, count=count):
                harness = (
                    'const files = ' + json.dumps(files) + ';\n'
                    'const context = {repo: {}, issue: {number: 1}, payload: '
                    '{pull_request: {changed_files: ' + str(count) + '}}};\n'
                    'const github = {rest: {pulls: {listFiles: null}}, '
                    'paginate: async () => files};\n'
                    'const core = {setOutput: (_, value) => console.log(String(value))};\n'
                    '(async () => {\n' + script + '\n})().catch(() => process.exit(1));'
                )
                result = subprocess.run(["node", "-e", harness], capture_output=True,
                                        text=True, timeout=10)
                if expected == "error":
                    self.assertNotEqual(result.returncode, 0)
                else:
                    self.assertEqual(result.returncode, 0, result.stderr)
                    self.assertEqual(result.stdout.strip(), str(expected).lower())

    def test_required_check_fails_closed(self):
        script = textwrap.dedent(WORKFLOW.rsplit("        run: |\n", 1)[1])
        # Only these combinations may permit merging.
        for changes in ("success", "failure", "cancelled", "skipped"):
            for changed in ("true", "false", ""):
                for tests in ("success", "failure", "cancelled", "skipped"):
                    with self.subTest(changes=changes, changed=changed, tests=tests):
                        env = dict(os.environ, CHANGES_RESULT=changes,
                                   SETUP_CHANGED=changed, TEST_RESULT=tests)
                        result = subprocess.run(["bash", "-e", "-c", script],
                                                env=env, timeout=10, capture_output=True)
                        expected = changes == "success" and (
                            (changed == "true" and tests == "success") or
                            (changed == "false" and tests == "skipped"))
                        self.assertEqual(result.returncode == 0, expected)
