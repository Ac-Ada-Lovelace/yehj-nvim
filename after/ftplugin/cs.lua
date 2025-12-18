-- C# 文件类型专属配置
-- 自动禁用单文件的 OmniSharp LSP

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

-- 如果不在项目中，禁用 OmniSharp
if not is_in_project() then
  vim.defer_fn(function()
    local clients = vim.lsp.get_clients({ bufnr = 0, name = "omnisharp" })
    for _, client in ipairs(clients) do
      vim.lsp.buf_detach_client(0, client.id)
    end
  end, 500)

  -- 可选：显示提示
  -- vim.notify("Single C# file - LSP disabled", vim.log.levels.INFO)
end
