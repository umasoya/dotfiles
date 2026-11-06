-- Keep editing usable without plugins or language servers.
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Older Neovim can still edit files; LSP configuration needs 0.12+.
if vim.fn.has('nvim-0.12') == 0 then
    return
end

local ruby_trust = require('dotfiles.ruby_trust')

local servers = {
    ts_ls = {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
        init_options = { hostInfo = 'neovim' },
    },
    gopls = {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_markers = { 'go.work', 'go.mod', '.git' },
    },
    ruby_lsp = {
        cmd = { 'ruby-lsp' },
        filetypes = { 'ruby', 'eruby' },
        root_markers = { 'Gemfile', '.git' },
    },
    marksman = {
        cmd = { 'marksman', 'server' },
        filetypes = { 'markdown' },
        root_markers = { '.marksman.toml', '.git' },
    },
    jsonls = {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc' },
        root_markers = { '.git' },
        init_options = { provideFormatter = true },
        settings = { json = { validate = { enable = true } } },
    },
    yamlls = {
        cmd = { 'yaml-language-server', '--stdio' },
        filetypes = { 'yaml' },
        root_markers = { '.git' },
        settings = { yaml = { validate = true, schemaStore = { enable = false } } },
    },
}

for name, server in pairs(servers) do
    local cmd = server.cmd
    local command = cmd[1]
    local markers = server.root_markers
    -- Check on each new buffer, so absent servers do not interrupt editing.
    server.root_dir = function(bufnr, on_dir)
        if vim.fn.executable(command) ~= 1 then
            return
        end
        local path = vim.api.nvim_buf_get_name(bufnr)
        if path == '' then
            return
        end
        local root = vim.fs.root(bufnr, markers) or vim.fs.dirname(path)
        if name == 'ruby_lsp' then
            root = ruby_trust.root(bufnr)
            if not ruby_trust.is_trusted(root) then
                return
            end
        end
        on_dir(root)
    end
    -- In particular, Ruby LSP must discover the bundle from the project root.
    server.cmd = function(dispatchers, config)
        if name == 'ruby_lsp' then
            assert(ruby_trust.is_trusted(config.root_dir), 'Ruby LSP requires workspace trust')
        end
        return vim.lsp.rpc.start(cmd, dispatchers, { cwd = config.root_dir })
    end
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/completion') then
            -- Native completion and snippet support; no completion plugin needed.
            vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
        end
    end,
})
