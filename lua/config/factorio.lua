if true then
  return
end
local lspconfig_util = require("lspconfig.util")

local factorio_library = vim.fn.expand("~/repos/factorio-api/out/luals")

local function get_project_root()
  return lspconfig_util.find_git_ancestor(vim.fn.getcwd()) or vim.fn.getcwd()
end

local function ensure_factorio_library(client)
  local settings = client.config.settings or {}
  settings.Lua = settings.Lua or {}
  settings.Lua.workspace = settings.Lua.workspace or {}
  settings.Lua.workspace.library = settings.Lua.workspace.library or {}
  settings.Lua.workspace.library[factorio_library] = true
  settings.Lua.workspace.checkThirdParty = false
  client.config.settings = settings
  client.notify("workspace/didChangeConfiguration", { settings = settings })
end

vim.api.nvim_create_user_command("InitFactorioMod", function()
  local root = get_project_root()
  local flag = lspconfig_util.path.join(root, ".factorio-mod")

  if vim.fn.filereadable(flag) == 0 then
    vim.fn.writefile({}, flag)
  end

  if vim.fn.isdirectory(factorio_library) == 0 then
    vim.notify("Factorio LuaLS library not found: " .. factorio_library, vim.log.levels.WARN)
  end

  for _, client in pairs(vim.lsp.get_active_clients()) do
    if client.name == "lua_ls" then
      ensure_factorio_library(client)
    end
  end

  vim.notify("Factorio mod env enabled at: " .. root, vim.log.levels.INFO)
end, {})

vim.cmd("cabbrev init-factorio-mod InitFactorioMod")
