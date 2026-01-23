-- 修复 OmniSharp 处理单文件的问题
-- 对于没有项目文件的 .cs 文件，禁用 LSP

local M = {}

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

-- 自动命令：打开 C# 文件时检查
function M.setup()
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.cs",
    callback = function()
      -- 如果不在项目中，停止 LSP
      if not is_in_project() then
        vim.defer_fn(function()
          -- 停止当前 buffer 的 OmniSharp（避免单文件误启动/报错）
          local clients = vim.lsp.get_clients({ bufnr = 0, name = "omnisharp" })
          for _, client in ipairs(clients) do
            vim.lsp.stop_client(client.id, true)
          end
        end, 100)
      end
    end,
  })
end

return M
