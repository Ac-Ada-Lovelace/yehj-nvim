-- C# 文件类型专属配置
-- 防止 OmniSharp 被自动启用（改用 csharp_ls）
if true then
  return {}
end

pcall(vim.lsp.enable, "csharp_ls")

-- 检查是否在项目环境中
local function is_in_project()
  local file = vim.fn.expand("%:p")
  if file == "" then
    return false
  end

  local dir = vim.fs.dirname(file)
  local csproj = vim.fs.find({ "*.csproj" }, { upward = true, type = "file", path = dir })[1]
  local sln = vim.fs.find({ "*.sln" }, { upward = true, type = "file", path = dir })[1]

  return csproj ~= nil or sln ~= nil
end

local function stop_clients(name)
  local clients = vim.lsp.get_clients({ name = name })
  for _, client in ipairs(clients) do
    vim.lsp.stop_client(client.id, true)
  end
end

-- 始终确保 OmniSharp 不会挂在 C# buffer 上（避免 INVALID_SERVER_MESSAGE 等噪音）
stop_clients("omnisharp")

-- 如果不在项目中，可选：禁用 C# LSP（避免单文件场景下的误启动/误提示）
if not is_in_project() then
  -- stop_clients("csharp_ls")
end
