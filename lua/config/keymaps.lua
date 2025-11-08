-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "g9", "<C-o>", { desc = "Jump back in history" })
vim.keymap.set("n", "g0", "<C-i>", { desc = "Jump forward in history" })
