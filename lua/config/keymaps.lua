-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "g9", "<C-o>", { desc = "Jump back in history" })
vim.keymap.set("n", "g0", "<C-i>", { desc = "Jump forward in history" })

vim.keymap.set({ "i", "s" }, "jk", function()
  vim.cmd("noh")
  LazyVim.cmp.actions.snippet_stop()
  return "<Esc>"
end, { expr = true, desc = "Escape insert mode" })

vim.keymap.set("n", "<leader>bo", function()
  local ok, groups = pcall(require, "bufferline.groups")
  Snacks.bufdelete({
    filter = function(buf)
      if buf == vim.api.nvim_get_current_buf() then
        return false
      end
      if ok and groups._is_pinned({ id = buf }) then
        return false
      end
      return true
    end,
  })
end, { desc = "Delete Other Buffers (skip pinned)" })

vim.keymap.set("n", "<leader>bO", function()
  Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })

