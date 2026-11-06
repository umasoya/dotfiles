"""Run editor checks in an isolated home; opt into real language-server checks."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
NVIM = os.environ.get("NVIM_TEST_EXECUTABLE") or shutil.which("nvim")
SERVER_PATH = os.environ.get("NVIM_TEST_SERVER_PATH")


@unittest.skipUnless(NVIM, "Neovim is not installed")
class NeovimTests(unittest.TestCase):
    def run_editor(self, filename, content, script, server_path="/usr/bin:/bin"):
        with tempfile.TemporaryDirectory(prefix="dotfiles-nvim-") as tmp:
            home = Path(tmp)
            config = home / "config/nvim"
            config.parent.mkdir()
            config.symlink_to(ROOT / "config/nvim", target_is_directory=True)
            project = home / "project"
            project.mkdir()
            (project / ".git").mkdir()
            (project / "go.mod").write_text("module example.com/editorcheck\n\ngo 1.19\n")
            (project / "package.json").write_text('{"private":true}\n')
            target = project / filename
            target.write_text(content)
            check = home / "check.lua"
            check.write_text("local ok, err = pcall(function()\n" + script + "\nend)\n"
                             "if not ok then print(err); vim.cmd('cquit') end\n"
                             "vim.cmd('qa!')\n")
            env = {**os.environ, "HOME": tmp, "XDG_CONFIG_HOME": str(home / "config"),
                   "XDG_DATA_HOME": str(home / "data"), "XDG_STATE_HOME": str(home / "state"),
                   "XDG_CACHE_HOME": str(home / "cache"), "PATH": server_path,
                   "GOTOOLCHAIN": "local", "NVIM_LOG_FILE": str(home / "nvim.log")}
            for name in ("VIMINIT", "EXINIT", "NVIM_APPNAME", "VIM", "VIMRUNTIME"):
                env.pop(name, None)
            result = subprocess.run(
                [NVIM, "--headless", "-i", "NONE", "-n", str(target), "-c", "luafile " + str(check)],
                cwd=project, env=env, capture_output=True, text=True, timeout=45,
            )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertNotIn("Error", result.stderr)

    def setUp(self):
        result = subprocess.run([NVIM, "--version"], capture_output=True, text=True)
        version = result.stdout.splitlines()[0].split("v", 1)[1].split(".")
        if tuple(map(int, version[:2])) < (0, 11):
            self.skipTest("LSP checks require Neovim 0.11+")

    def test_unrelated_file_uses_plain_editing(self):
        self.run_editor("example.txt", "example\nExample\nEXAMPLE\n", '''
assert(vim.o.number and vim.o.hlsearch)
vim.fn.cursor(1, 1)
assert(vim.fn.search('example', 'W') == 2)
assert(vim.fn.search('example', 'W') == 3)
vim.fn.cursor(1, 1)
assert(vim.fn.search('Example', 'W') == 2)
assert(vim.fn.search('Example', 'W') == 0)
vim.wait(200)
assert(#vim.lsp.get_clients() == 0)
assert(vim.fn.maparg('gd', 'n') == '')
''')

    def test_missing_language_server_keeps_editing_usable(self):
        self.run_editor("example.ts", "const value = 1;\n", '''
assert(vim.fn.executable('typescript-language-server') == 0)
vim.wait(200)
assert(#vim.lsp.get_clients() == 0)
vim.api.nvim_buf_set_lines(0, 0, 1, false, { 'const value = 2;' })
vim.cmd('write')
assert(vim.fn.getline(1) == 'const value = 2;')
''')

    @unittest.skipUnless(SERVER_PATH, "Set NVIM_TEST_SERVER_PATH for real LSP checks")
    def test_installed_servers_attach(self):
        cases = [
            ("example.tsx", "const value = 1;\nconsole.log(value);\n", "ts_ls"),
            ("main.go", "package main\nfunc main() {}\n", "gopls"),
            ("README.md", "# Example\n", "marksman"),
            ("example.json", '{"value": }\n', "jsonls"),
            ("example.yaml", "value: 1\n", "yamlls"),
        ]
        for filename, content, server in cases:
            with self.subTest(server=server):
                self.run_editor(filename, content, '''
assert(vim.wait(20000, function()
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        if client.name == '%s' and client.initialized then return true end
    end
    return false
end), 'Language server did not attach: %s')
assert(vim.bo.omnifunc ~= '')
local client = vim.lsp.get_clients({ bufnr = 0 })[1]
if client.name == 'jsonls' then
    assert(vim.wait(10000, function()
        return #vim.diagnostic.get(0) > 0
    end), 'Invalid JSON did not produce diagnostics')
elseif client.name == 'ts_ls' then
    local response = client:request_sync('textDocument/definition', {
        textDocument = { uri = vim.uri_from_bufnr(0) },
        position = { line = 1, character = 13 },
    }, 10000, 0)
    assert(response and not response.err and response.result and #response.result > 0,
        'TypeScript definition lookup failed')
end
''' % (server, server), SERVER_PATH)
