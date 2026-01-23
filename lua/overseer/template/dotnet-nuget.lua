local overseer = require("overseer")

local function find_csproj()
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(buf)
  local start = path ~= "" and vim.fs.dirname(path) or vim.loop.cwd()
  return vim.fs.find({ "*.csproj" }, { upward = true, type = "file", path = start })[1]
end

return {
  name = "Dotnet: NuGet",
  desc = "Add, remove, list packages or clear NuGet caches",
  builder = function(params)
    if params.action == "clear-cache" then
      return {
        cmd = { "dotnet", "nuget", "locals", "all", "--clear" },
        components = { "default" },
      }
    end

    local csproj = find_csproj()
    if not csproj then
      error("No .csproj found for NuGet operations")
    end

    if params.action ~= "list" and (not params.package or params.package == "") then
      error("Package name is required")
    end

    local cmd
    if params.action == "add" then
      cmd = { "dotnet", "add", csproj, "package", params.package }
      if params.version and params.version ~= "" then
        vim.list_extend(cmd, { "--version", params.version })
      end
    elseif params.action == "remove" then
      cmd = { "dotnet", "remove", csproj, "package", params.package }
    elseif params.action == "list" then
      cmd = { "dotnet", "list", csproj, "package" }
    else
      error(string.format("Unsupported action: %s", params.action))
    end

    return {
      cmd = cmd,
      cwd = vim.fs.dirname(csproj),
      components = {
        { "on_output_quickfix", open = false },
        "default",
      },
    }
  end,
  condition = {
    callback = function()
      -- Only show if dotnet is available and we're in a .NET project
      if vim.fn.executable("dotnet") ~= 1 then
        return false
      end

      local buf = vim.api.nvim_get_current_buf()
      local path = vim.api.nvim_buf_get_name(buf)
      local start = path ~= "" and vim.fs.dirname(path) or vim.loop.cwd()
      local csproj = vim.fs.find({ "*.csproj", "*.fsproj" }, { upward = true, type = "file", path = start })[1]

      return csproj ~= nil
    end,
  },
  tags = { overseer.TAG.BUILD },
  params = {
    action = {
      type = "enum",
      name = "Action",
      default = "add",
      choices = {
        { value = "add", desc = "dotnet add <project> package <pkg>" },
        { value = "remove", desc = "dotnet remove <project> package <pkg>" },
        { value = "list", desc = "dotnet list <project> package" },
        { value = "clear-cache", desc = "dotnet nuget locals all --clear" },
      },
    },
    package = {
      name = "Package name",
      type = "string",
      optional = true,
    },
    version = {
      name = "Version (for add)",
      type = "string",
      optional = true,
    },
  },
}
