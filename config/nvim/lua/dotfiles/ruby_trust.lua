-- Trust is local state, never executable configuration from the workspace.
local M = {}
local database = vim.fn.stdpath('state') .. '/ruby-lsp-trust.json'

function M.root(bufnr)
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path == '' then
        return nil
    end
    local root = vim.fs.root(bufnr, { 'Gemfile', '.git' }) or vim.fs.dirname(path)
    return vim.uv.fs_realpath(root)
end

local function read_roots()
    local ok, lines = pcall(vim.fn.readfile, database)
    if not ok then
        return {}
    end
    local decoded, roots = pcall(vim.json.decode, table.concat(lines, '\n'))
    if not decoded or type(roots) ~= 'table' then
        return {}
    end
    return roots
end

function M.is_trusted(root)
    local real = root and vim.uv.fs_realpath(root)
    return real ~= nil and read_roots()[real] == true
end

local function save(root, trusted)
    local roots = read_roots()
    roots[root] = trusted or nil
    local temp = database .. '.' .. vim.fn.getpid() .. '.tmp'
    local ok, err = pcall(function()
        vim.fn.mkdir(vim.fs.dirname(database), 'p', 448) -- 0700
        assert(vim.fn.writefile({ vim.json.encode(roots) }, temp) == 0)
        assert(vim.fn.setfperm(temp, 'rw-------') == 1)
        assert(vim.uv.fs_rename(temp, database))
    end)
    if not ok then
        vim.fn.delete(temp)
        vim.notify('Ruby LSP trust could not be saved: ' .. tostring(err), vim.log.levels.ERROR)
    end
    return ok
end

local function current_root()
    if not vim.tbl_contains({ 'ruby', 'eruby' }, vim.bo.filetype) then
        vim.notify('Open a Ruby or ERB file first.', vim.log.levels.WARN)
        return nil
    end
    return M.root(0)
end

vim.api.nvim_create_user_command('RubyLspTrust', function()
    local root = current_root()
    if not root then
        return
    end
    local choice = vim.fn.confirm(
        'Trust this project for Ruby LSP?\n' .. root
            .. '\nGemfile, dependency installation hooks and workspace add-ons may execute code.',
        '&Cancel\n&Trust', 1
    )
    if choice ~= 2 or not save(root, true) then
        return
    end
    -- Start already-open buffers too; future buffers use the normal LSP activation.
    if vim.fn.executable('ruby-lsp') == 1 then
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(bufnr)
                and vim.tbl_contains({ 'ruby', 'eruby' }, vim.bo[bufnr].filetype)
                and M.root(bufnr) == root then
                local config = vim.tbl_extend('force', vim.lsp.config.ruby_lsp, { root_dir = root })
                vim.lsp.start(config, { bufnr = bufnr })
            end
        end
    end
    vim.notify('Ruby LSP project trusted: ' .. root)
end, { desc = 'Trust the current Ruby project and start Ruby LSP' })

vim.api.nvim_create_user_command('RubyLspUntrust', function()
    local root = current_root()
    if not root or not save(root, false) then
        return
    end
    for _, client in ipairs(vim.lsp.get_clients({ name = 'ruby_lsp' })) do
        if vim.uv.fs_realpath(client.config.root_dir) == root then
            client:stop(true)
        end
    end
    vim.notify('Ruby LSP project trust revoked: ' .. root)
end, { desc = 'Revoke trust and stop Ruby LSP for the current project' })

return M
