return {
  {
    "ojroques/nvim-osc52",
    event = "VeryLazy",
    config = function()
      local osc52 = require("osc52")

      osc52.setup({
        max_length = 0,
        silent = false,
        trim = false,
      })

      local function is_wsl()
        return vim.env.WSL_DISTRO_NAME ~= nil or vim.env.WSL_INTEROP ~= nil
      end

      local function win32yank_path()
        if vim.fn.executable("win32yank.exe") == 1 then
          return "win32yank.exe"
        end

        local candidates = {
          "/mnt/c/Users/YehJ/AppData/Local/Microsoft/WinGet/Links/win32yank.exe",
        }

        for _, path in ipairs(candidates) do
          if vim.fn.executable(path) == 1 then
            return path
          end
          if vim.fn.filereadable(path) == 1 then
            return path
          end
        end
      end

      -- Prefer win32yank on WSL, OSC52 on SSH.
      local win32yank = win32yank_path()

      if is_wsl() and win32yank then
        vim.g.clipboard = {
          name = "win32yank",
          copy = {
            ["+"] = win32yank .. " -i --crlf",
            ["*"] = win32yank .. " -i --crlf",
          },
          paste = {
            ["+"] = win32yank .. " -o --lf",
            ["*"] = win32yank .. " -o --lf",
          },
        }
      elseif vim.env.SSH_TTY or vim.env.SSH_CONNECTION or vim.env.SSH_CLIENT then
        vim.g.clipboard = {
          name = "osc52",
          copy = {
            ["+"] = osc52.copy_register("+"),
            ["*"] = osc52.copy_register("*"),
          },
          paste = {
            ["+"] = osc52.paste_register("+"),
            ["*"] = osc52.paste_register("*"),
          },
        }
      end
    end,
    keys = {
      {
        "<leader>y",
        function()
          return require("osc52").copy_operator()
        end,
        expr = true,
        desc = "OSC52 copy operator",
      },
      {
        "<leader>yy",
        "<leader>y_",
        remap = true,
        desc = "OSC52 copy line",
      },
      {
        "<leader>y",
        function()
          require("osc52").copy_visual()
        end,
        mode = "v",
        desc = "OSC52 copy selection",
      },
    },
  },
}
