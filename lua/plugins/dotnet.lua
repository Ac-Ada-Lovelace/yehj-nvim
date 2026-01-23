return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local lspconfig_util = require("lspconfig.util")
      opts.servers = opts.servers or {}
      local data_dir = vim.fn.stdpath("data")
      local mason_bin = data_dir .. "/mason/bin/omnisharp"
      local mason_bin_alt = data_dir .. "/mason/bin/OmniSharp"
      local omnisharp_bin = vim.fn.executable(mason_bin) == 1 and mason_bin
        or (vim.fn.executable(mason_bin_alt) == 1 and mason_bin_alt)
        or (vim.fn.executable("omnisharp") == 1 and "omnisharp")
        or "OmniSharp"

      opts.servers.omnisharp = {
        cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
        filetypes = { "cs" },
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          local root = lspconfig_util.root_pattern("*.sln", "*.slnx", "*.csproj", ".git")(fname)
          on_dir(root)
        end,
        single_file_support = false,

        -- Full-solution analysis (not just opened buffers).
        analyze_open_documents_only = false,

        -- Better completion/import experience.
        enable_import_completion = true,
        enable_roslyn_analyzers = true,
        enable_editorconfig_support = true,

        -- Ensure workspace loads fully (useful for navigation/diagnostics across the solution).
        -- If you later feel OmniSharp too heavy, set this to true to reduce load.
        -- MsBuild = { LoadProjectsOnDemand = false },
      }

      -- Filter known noisy OmniSharp notifications.
      require("config.disable-lsp-errors")

      return opts
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "omnisharp",
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
