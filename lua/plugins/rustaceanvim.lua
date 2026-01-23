-- Rust support with default CodeLens
return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(client, bufnr)
          -- Keymap for running codelens
          vim.keymap.set("n", "<leader>cc", vim.lsp.codelens.run, {
            buffer = bufnr,
            desc = "Run CodeLens",
          })

          -- Auto import 快捷键
          vim.keymap.set("n", "<leader>ci", function()
            vim.cmd.RustLsp("openCargo")
          end, {
            buffer = bufnr,
            desc = "Open Cargo.toml",
          })

          -- 快速添加缺失的 use 语句
          vim.keymap.set("n", "<leader>cI", function()
            vim.lsp.buf.code_action({
              context = {
                only = { "quickfix" },
                diagnostics = {},
              },
            })
          end, {
            buffer = bufnr,
            desc = "Auto Import (quickfix)",
          })

          -- Enable codelens auto-refresh
          if client.server_capabilities.codeLensProvider then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = bufnr,
              callback = vim.lsp.codelens.refresh,
            })
          end
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              -- 这几项对大型 workspace 的内存/CPU 影响很大，默认关掉更稳
              allTargets = false,
              allFeatures = false,
              loadOutDirsFromCheck = false,
              buildScripts = {
                enable = false,
              },
            },
            -- 诊断：仅在保存时跑一次 `cargo check`，避免持续后台检查拉爆资源
            checkOnSave = true,
            check = {
              command = "check",
              allTargets = false,
              extraArgs = {},
            },
            -- 诊断配置
            diagnostics = {
              enable = true,
              experimental = {
                enable = false,
              },
              disabled = {}, -- 不禁用任何诊断
              -- 显示更多诊断信息
              warningsAsHint = {}, -- 将警告显示为提示
              warningsAsInfo = {}, -- 将警告显示为信息
            },
            files = {
              exclude = { "target" },
            },
            -- 自动导入配置
            imports = {
              granularity = {
                group = "module", -- 按模块分组导入
              },
              prefix = "self", -- 使用 self:: 前缀
              merge = {
                glob = false, -- 不合并为 glob 导入 (use std::*;)
              },
            },
            completion = {
              -- 补全时自动导入
              autoimport = {
                enable = true,
              },
              -- 显示完整路径
              fullFunctionSignatures = {
                enable = true,
              },
            },
            procMacro = {
              enable = true,
              attributes = {
                enable = true,
              },
            },
            -- 实时更新
            updates = {
              channel = "stable",
            },
            -- Enable CodeLens features
            lens = {
              enable = true,
              run = {
                enable = true,
              },
              debug = {
                enable = true,
              },
              implementations = {
                enable = false,
              },
              references = {
                adt = {
                  enable = false,
                },
                enumVariant = {
                  enable = false,
                },
                method = {
                  enable = false,
                },
                trait = {
                  enable = false,
                },
              },
            },
          },
        },
      },
      tools = {
        hover_actions = {
          auto_focus = false,
        },
      },
      dap = {
        adapter = {
          type = "executable",
          command = "lldb-vscode",
          name = "rt_lldb",
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
}
