-- if true then
--   return {}
-- end
return {

  {
    "CWood-sdf/pineapple",
    dependencies = require("plugins.installed-colorscheme"),
    opts = {
      installedRegistry = "plugins.installed-colorscheme",
      colorschemeFile = "after/plugin/theme.lua",
    },
    config = function(_, opts)
      require("pineapple").setup(opts)

      local buffer = require("pineapple.ui.buffer")
      buffer._pineapple_win = buffer._pineapple_win or nil
      buffer.getWinNr = function()
        return buffer._pineapple_win
      end

      local function set_size(width, height)
        if debug and debug.setupvalue and debug.getupvalue then
          local name = debug.getupvalue(buffer.getWidth, 1)
          if name == "width" then
            debug.setupvalue(buffer.getWidth, 1, width)
          end
          name = debug.getupvalue(buffer.getHeight, 1)
          if name == "height" then
            debug.setupvalue(buffer.getHeight, 1, height)
          end
        end
      end

      buffer.openWindow = function()
        local win = buffer.getWinNr()
        if vim.api.nvim_win_is_valid(win or -1) then
          vim.api.nvim_set_current_win(win or -1)
          vim.api.nvim_win_set_buf(win or -1, buffer.getBufNr())
        else
          vim.cmd("botright vsplit")
          win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.4))
          vim.api.nvim_win_set_buf(win, buffer.getBufNr())
          buffer._pineapple_win = win
        end
        set_size(vim.api.nvim_win_get_width(win), vim.api.nvim_win_get_height(win))
        buffer.refreshBuffer()
      end
    end,
    cmd = "Pineapple",
  },
}
