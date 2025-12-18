return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local lspconfig_util = require("lspconfig.util")
      opts.servers = opts.servers or {}
      opts.servers.csharp_ls = {
        root_dir = function(fname)
          return lspconfig_util.root_pattern("*.sln", "*.csproj", ".git")(fname)
        end,
      }
      return opts
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "csharp-language-server",
        "netcoredbg",
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "netcoredbg") then
        table.insert(opts.ensure_installed, "netcoredbg")
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    opts = function(_, opts)
      local dap = require("dap")
      if not dap.adapters.netcoredbg then
        dap.adapters.netcoredbg = {
          type = "executable",
          command = "netcoredbg",
          args = { "--interpreter=vscode" },
        }
      end
      dap.configurations.cs = dap.configurations.cs
        or {
          {
            type = "netcoredbg",
            name = "Launch .NET",
            request = "launch",
            program = function()
              return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
            end,
          },
        }
      return opts
    end,
  },
}
