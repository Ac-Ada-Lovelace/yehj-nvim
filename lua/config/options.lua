-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.termguicolors = true
vim.opt.scrolloff = 10 -- keep cursor away from the very top/bottom rows
vim.opt.sidescrolloff = 8 -- add similar gap on the horizontal axis

-- soft-wrap long lines in the UI without inserting newlines
vim.opt.wrap = true
vim.opt.linebreak = true -- wrap at word boundaries
vim.opt.breakindent = true

vim.opt.swapfile = false
-- auto comp

-- use four-space indents by default
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
