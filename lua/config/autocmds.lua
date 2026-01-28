-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local autosave = vim.api.nvim_create_augroup("lazyvim_autosave_on_leave", { clear = true })

-- Save real file buffers when leaving them or when Neovim loses focus.
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  group = autosave,
  callback = function(event)
    local buf = event.buf
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    local bo = vim.bo[buf]
    if bo.readonly or not bo.modifiable or bo.buftype ~= "" then
      return
    end

    local ok_name, name = pcall(vim.api.nvim_buf_get_name, buf)
    if not ok_name or name == "" then
      return
    end

    if bo.modified then
      pcall(vim.api.nvim_buf_call, buf, function()
        vim.cmd("silent! write")
      end)
    end
  end,
})

local snippet_cleanup = vim.api.nvim_create_augroup("lazyvim_snippet_cleanup", { clear = true })

-- stop active snippets when leaving insert/select mode via any means
vim.api.nvim_create_autocmd("ModeChanged", {
  group = snippet_cleanup,
  callback = function(event)
    if event.old_mode and event.old_mode:match("[is]") and (not event.new_mode:match("[is]")) then
      LazyVim.cmp.actions.snippet_stop()
    end
  end,
})

local terminal_keymaps = vim.api.nvim_create_augroup("lazyvim_terminal_keymaps", { clear = true })

-- Make it easy to exit any terminal buffer (Overseer, toggleterm, built-in)
vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter", "BufEnter" }, {
  group = terminal_keymaps,
  pattern = "*",
  callback = function(event)
    local buf = event.buf
    if vim.bo[buf].buftype ~= "terminal" then
      return
    end
    if vim.b[buf].lazyvim_terminal_keymaps_applied then
      return
    end

    local opts = { buffer = buf }
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
    vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
    vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
    vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)

    -- Reduce UI overhead for terminal buffers to improve responsiveness.
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.cursorline = false
    vim.opt_local.cursorcolumn = false
    vim.opt_local.foldcolumn = "0"
    vim.opt_local.list = false
    vim.opt_local.wrap = false
    vim.opt_local.spell = false
    vim.opt_local.colorcolumn = ""

    vim.b[buf].lazyvim_terminal_keymaps_applied = true
  end,
})

local markdown_options = vim.api.nvim_create_augroup("lazyvim_markdown_options", { clear = true })

-- Disable spelling in Markdown files by default
vim.api.nvim_create_autocmd("FileType", {
  group = markdown_options,
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false
  end,
})

local colorscheme_persist = vim.api.nvim_create_augroup("lazyvim_colorscheme_persist", { clear = true })

-- Persist the last chosen colorscheme so <leader>uC survives restarts.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = colorscheme_persist,
  callback = function()
    local name = vim.g.colors_name
    if not name or name == "" then
      return
    end
    local theme_file = vim.fn.stdpath("config") .. "/after/plugin/theme.lua"
    vim.fn.mkdir(vim.fn.fnamemodify(theme_file, ":h"), "p")
    vim.fn.writefile({ string.format('vim.cmd("colorscheme %s")', name) }, theme_file)
  end,
})

require("config.transparent")
require("config.factorio")
