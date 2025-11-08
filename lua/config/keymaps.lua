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

local function get_a_float_term(cmd)
  return require("toggleterm.terminal").Terminal:new({
    cmd = cmd,
    hidden = true,
    direction = "float",
    float_opts = {
      border = "curved",
    },
  })
end

-- set gg to lazygit
vim.keymap.set("n", "<leader>gt", function()
  get_a_float_term("lazygit"):toggle()
end, { desc = "Toggle LazyGit" })
-- pop a input, and get a float terminal to run the input command
vim.keymap.set("n", "<leader>jj", function()
  vim.ui.input({ prompt = "Command to run in float terminal: " }, function(input)
    if input and input ~= "" then
      get_a_float_term(input):toggle()
    end
  end)
end, { desc = "Run command in floating terminal" })
