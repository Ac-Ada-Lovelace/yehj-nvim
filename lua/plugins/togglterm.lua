local float_term
local lazygit_term
local command_runner_term
local codex_term

local function new_float_terminal(cmd, extra_opts)
  local Terminal = require("toggleterm.terminal").Terminal
  local opts = {
    hidden = true,
    direction = "float",
    float_opts = {
      border = "curved",
    },
  }

  if cmd and cmd ~= "" then
    opts.cmd = cmd
  end

  if extra_opts then
    opts = vim.tbl_deep_extend("force", opts, extra_opts)
  end

  return Terminal:new(opts)
end

local function toggle_float_terminal()
  if not float_term then
    float_term = new_float_terminal()
  end
  float_term:toggle()
end

local function toggle_lazygit()
  if not lazygit_term then
    lazygit_term = new_float_terminal("lazygit")
  end
  lazygit_term:toggle()
end

local function toggle_codex()
  if not codex_term then
    codex_term = new_float_terminal("codex")
  end
  codex_term:toggle()
end

local function toggle_command_runner()
  if command_runner_term then
    command_runner_term:toggle()
    return
  end

  vim.ui.input({ prompt = "Command to run in float terminal: " }, function(cmd)
    if not cmd or cmd == "" then
      return
    end

    command_runner_term = new_float_terminal(cmd)
    command_runner_term.on_exit = function()
      command_runner_term = nil
    end

    command_runner_term:toggle()
  end)
end

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local toggleterm = require("toggleterm")

      toggleterm.setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return math.floor(vim.o.columns * 0.4)
          end
          return 20
        end,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        persist_mode = true,
        persist_size = true,
        start_in_insert = true,
        direction = "horizontal",
        close_on_exit = true,
        float_opts = {
          border = "curved",
        winblend = 0,
      },
    })
    end,
    keys = {
      {
        "<leader>jt",
        function()
          vim.cmd("ToggleTerm")
        end,
        mode = { "n", "t" },
        desc = "Toggle terminal",
      },
      {
        "<leader>jl",
        function()
          vim.cmd("TermSelect")
        end,
        mode = { "n", "t" },
        desc = "Show terminal list",
      },
      {
        "<leader>jF",
        toggle_float_terminal,
        mode = { "n", "t" },
        desc = "Toggle floating terminal",
      },
      {
        "<leader>jg",
        toggle_lazygit,
        mode = { "n", "t" },
        desc = "Toggle LazyGit",
      },
      {
        "<leader>jc",
        toggle_codex,
        mode = { "n", "t" },
        desc = "Toggle Codex terminal",
      },
      {
        "<leader>jj",
        toggle_command_runner,
        mode = { "n" },
        desc = "Run command in floating terminal",
      },
    },
  },
}
