vim.cmd("autocmd!")

vim.scriptencoding = "utf-8"
vim.wo.number = true

# does not work on wsl2.
vim.opt.clipboard:append{'unnamedplus'}
