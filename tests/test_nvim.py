"""Run editor checks in an isolated home; opt into real language-server checks."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
NVIM = os.environ.get("NVIM_TEST_EXECUTABLE") or shutil.which("nvim")
SERVER_PATH = os.environ.get("NVIM_TEST_SERVER_PATH")


@unittest.skipUnless(NVIM, "Neovim is not installed")
class NeovimTests(unittest.TestCase):
    def run_editor(self, filename, content, script, server_path="/usr/bin:/bin", ruby_stub=False):
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
            env = {**os.environ, "HOME": tmp, "XDG_CONFIG_HOME": str(home / "config"),
                   "XDG_DATA_HOME": str(home / "data"), "XDG_STATE_HOME": str(home / "state"),
                   "XDG_CACHE_HOME": str(home / "cache"), "PATH": server_path,
                   "GOTOOLCHAIN": "local", "NVIM_LOG_FILE": str(home / "nvim.log")}
            if ruby_stub:
                bin_dir = home / "bin"
                bin_dir.mkdir()
                stub = bin_dir / "ruby-lsp"
                stub.write_text("#!" + sys.executable + "\n" +
                                (ROOT / "tests/fixtures/ruby_lsp_stub.py").read_text())
                stub.chmod(0o755)
                env["PATH"] = str(bin_dir) + ":" + server_path
                env["RUBY_LSP_START_LOG"] = str(home / "ruby-starts")
            for name in ("VIMINIT", "EXINIT", "NVIM_APPNAME", "VIM", "VIMRUNTIME"):
                env.pop(name, None)
            for stage in script if isinstance(script, list) else [script]:
                check.write_text("local ok, err = pcall(function()\n" + stage + "\nend)\n"
                                 "if not ok then print(err); vim.cmd('cquit') end\n"
                                 "vim.cmd('qa!')\n")
                result = subprocess.run(
                    [NVIM, "--headless", "-i", "NONE", "-n", str(target), "-c", "luafile " + str(check)],
                    cwd=project, env=env, capture_output=True, text=True, timeout=45,
                )
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                self.assertNotIn("Error", result.stderr)

    def setUp(self):
        result = subprocess.run([NVIM, "--version"], capture_output=True, text=True)
        version = result.stdout.splitlines()[0].split("v", 1)[1].split(".")
        if tuple(map(int, version[:2])) < (0, 12):
            self.skipTest("LSP checks require Neovim 0.12+")

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

    def test_ruby_workspace_trust_lifecycle(self):
        self.run_editor("example.rb", "puts 'hello'\n", ['''
local log = vim.env.RUBY_LSP_START_LOG
local trust = require('dotfiles.ruby_trust')
local root = trust.root(0)
vim.wait(200)
assert(vim.fn.filereadable(log) == 0, 'Untrusted project executed Ruby LSP')
vim.fn.confirm = function(message, choices, default)
    assert(message:find(root, 1, true))
    assert(message:find('Gemfile', 1, true))
    assert(default == 1)
    return 1
end
vim.cmd('RubyLspTrust')
vim.wait(200)
assert(not trust.is_trusted(root))
assert(vim.fn.filereadable(log) == 0, 'Cancelled trust executed Ruby LSP')
vim.fn.confirm = function() return 2 end
vim.cmd('RubyLspTrust')
assert(vim.wait(5000, function()
    return #vim.lsp.get_clients({ bufnr = 0 }) == 1
end), 'Approved project did not start Ruby LSP')
assert(trust.is_trusted(root))
assert(vim.fn.readfile(log)[1] == root)
local other = vim.env.HOME .. '/other-worktree'
vim.fn.mkdir(other, 'p')
assert(not trust.is_trusted(other), 'Trust leaked to another worktree')
assert(not trust.is_trusted(vim.fs.dirname(root)), 'Trust leaked to parent')
vim.fn.mkdir(root .. '/child', 'p')
assert(not trust.is_trusted(root .. '/child'), 'Trust leaked to child')
local alias = vim.env.HOME .. '/project-alias'
assert(vim.uv.fs_symlink(root, alias))
assert(trust.is_trusted(alias), 'Equivalent real path was not recognized')
''', '''
-- A fresh editor must reuse the saved decision without prompting.
vim.fn.confirm = function() error('Unexpected automatic trust prompt') end
assert(vim.wait(5000, function()
    return #vim.lsp.get_clients({ bufnr = 0 }) == 1
end), 'Persisted trust did not enable startup')
local client = vim.lsp.get_clients({ bufnr = 0 })[1]
local root = require('dotfiles.ruby_trust').root(0)
vim.cmd('RubyLspUntrust')
assert(not require('dotfiles.ruby_trust').is_trusted(root))
assert(vim.wait(5000, function() return client:is_stopped() end))
''', '''
local log = vim.env.RUBY_LSP_START_LOG
local starts = #vim.fn.readfile(log)
vim.wait(200)
assert(#vim.lsp.get_clients() == 0, 'Revoked project restarted Ruby LSP')
assert(#vim.fn.readfile(log) == starts)
-- Invalid local state must fail closed.
vim.fn.writefile({ 'invalid json' }, vim.fn.stdpath('state') .. '/ruby-lsp-trust.json')
assert(not require('dotfiles.ruby_trust').is_trusted(require('dotfiles.ruby_trust').root(0)))
''', '''
vim.wait(200)
assert(#vim.lsp.get_clients() == 0, 'Invalid trust state started Ruby LSP')
'''], ruby_stub=True)
