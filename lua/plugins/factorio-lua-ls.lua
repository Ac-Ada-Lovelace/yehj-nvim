if true then
  return {}
end
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local lspconfig_util = require("lspconfig.util")
      local factorio_library = vim.fn.expand("~/repos/factorio-api/out/luals")

      local function maybe_enable_factorio_library(new_config, root_dir)
        local flag = lspconfig_util.path.join(root_dir, ".factorio-mod")
        if lspconfig_util.path.is_file(flag) then
          new_config.settings = new_config.settings or {}
          new_config.settings.Lua = new_config.settings.Lua or {}
          new_config.settings.Lua.workspace = new_config.settings.Lua.workspace or {}
          new_config.settings.Lua.workspace.library = new_config.settings.Lua.workspace.library or {}
          new_config.settings.Lua.workspace.library[factorio_library] = true
          new_config.settings.Lua.workspace.checkThirdParty = false
        end
      end

      opts.servers = opts.servers or {}
      opts.servers.lua_ls = opts.servers.lua_ls or {}

      local previous_on_new_config = opts.servers.lua_ls.on_new_config
      opts.servers.lua_ls.on_new_config = function(new_config, root_dir)
        if previous_on_new_config then
          previous_on_new_config(new_config, root_dir)
        end
        maybe_enable_factorio_library(new_config, root_dir)
      end

      return opts
    end,
  },
}
