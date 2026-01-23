-- Overseer template: Download LeetCode problem
local overseer = require("overseer")

return {
  name = "LeetCode: Edit/Download",
  desc = "Download a LeetCode problem by ID",
  builder = function(params)
    local id = params.problem_id
    if not id or id == "" then
      error("Problem ID is required")
    end

    return {
      cmd = { "leetcode", "edit", id },
      components = {
        { "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
        { "display_duration", detail_level = 2 },
        "default",
      },
    }
  end,
  condition = {
    callback = function()
      -- Only show in leetcode directories or when a leetcode file is open
      local cwd = vim.loop.cwd()
      local filename = vim.fn.expand("%:t")

      -- Check if in a leetcode directory (contains leetcode in path)
      local in_leetcode_dir = cwd:match("[Ll]eet[Cc]ode") ~= nil

      -- Check if current file is a leetcode file
      local is_leetcode_file = filename:match("^%d+%.") ~= nil

      -- Check if leetcode command is available
      local has_leetcode = vim.fn.executable("leetcode") == 1

      return has_leetcode and (in_leetcode_dir or is_leetcode_file)
    end,
  },
  priority = 50,
  tags = { overseer.TAG.BUILD },
  params = {
    problem_id = {
      type = "string",
      name = "Problem ID",
      desc = "LeetCode problem ID to download",
      default = "",
    },
  },
}
