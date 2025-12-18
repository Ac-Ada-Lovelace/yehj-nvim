local overseer = require("overseer")

local function find_dotnet_files()
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(buf)
  local start = path ~= "" and vim.fs.dirname(path) or vim.loop.cwd()
  local sln = vim.fs.find({ "*.sln" }, { upward = true, type = "file", path = start })[1]
  local csproj = vim.fs.find({ "*.csproj" }, { upward = true, type = "file", path = start })[1]
  return sln or csproj, sln, csproj
end

return {
  name = "Dotnet: solution task",
  desc = "Run dotnet build/test/restore/format/run against the closest solution or project",
  builder = function(params)
    local target, sln, csproj = find_dotnet_files()
    if not target then
      error("No .sln or .csproj found in current or parent directories")
    end

    local action = params.action or "build"
    local cwd = vim.fs.dirname(target)
    local cmd = { "dotnet" }

    local function add_config()
      if params.configuration and params.configuration ~= "" then
        vim.list_extend(cmd, { "-c", params.configuration })
      end
    end

    if action == "run" then
      if not csproj then
        error("dotnet run requires a project file")
      end
      vim.list_extend(cmd, { "run", "--project", csproj })
      add_config()
    elseif action == "watch run" then
      if not csproj then
        error("dotnet watch run requires a project file")
      end
      vim.list_extend(cmd, { "watch", "run", "--project", csproj })
      add_config()
    else
      vim.list_extend(cmd, { action, target })
      if action ~= "restore" then
        add_config()
      end
    end

    return {
      cmd = cmd,
      cwd = cwd,
      components = {
        { "on_output_quickfix", open = true, set_diagnostics = true },
        "default",
      },
    }
  end,
  condition = {
    callback = function()
      local target = find_dotnet_files()
      return target ~= nil
    end,
  },
  priority = 55,
  tags = { overseer.TAG.BUILD, overseer.TAG.RUN },
  params = {
    action = {
      type = "enum",
      name = "Command",
      default = "build",
      choices = { "build", "test", "restore", "clean", "format", "run", "watch run" },
    },
    configuration = {
      type = "enum",
      name = "Configuration",
      default = "Debug",
      choices = { "Debug", "Release" },
    },
  },
}
