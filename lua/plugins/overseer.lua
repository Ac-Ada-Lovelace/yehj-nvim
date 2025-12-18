local function register_user_templates(overseer)
  local dir = vim.fs.normalize(vim.fn.stdpath("config") .. "/templates")
  if vim.fn.isdirectory(dir) ~= 1 then
    return
  end

  local files = vim.fn.glob(dir .. "/**/*.lua", false, true)
  for _, file in ipairs(files) do
    local ok, template = pcall(dofile, file)
    if not ok then
      vim.notify(string.format("overseer template error in %s: %s", file, template), vim.log.levels.WARN)
    elseif template then
      overseer.register_template(template)
    end
  end
end

return {
  {
    "stevearc/overseer.nvim",

    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)
      register_user_templates(overseer)
    end,
  },
}
