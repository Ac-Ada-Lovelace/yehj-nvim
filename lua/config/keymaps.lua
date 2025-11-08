-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "g9", "<C-o>", { desc = "Jump back in history" })
vim.keymap.set("n", "g0", "<C-i>", { desc = "Jump forward in history" })

-- use quick tap j and k to escape
vim.keymap.set("i", "jk", "<Esc>", { desc = "Escape insert mode" })

local function toggle_lazygit_through_floaterm()
  local ToggleTerm = require("toggleterm.terminal").Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = {
      border = "curved",
    },
  })
  return ToggleTerm
end

-- set gg to lazygit
vim.keymap.set("n", "<leader>gt", function()
  toggle_lazygit_through_floaterm():toggle()
end, { desc = "Toggle LazyGit" })
