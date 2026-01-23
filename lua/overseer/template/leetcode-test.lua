-- Overseer template: Test LeetCode solution
local overseer = require("overseer")

-- Extract problem id from filename
local function get_problem_id()
  local filename = vim.fn.expand("%:t")
  if filename == "" then
    return nil
  end
  -- Extract id (first part before the first dot)
  return filename:match("^(%d+)%.")
end

return {
  name = "LeetCode: Test",
  desc = "Test current LeetCode solution with sample cases",
  builder = function()
    local id = get_problem_id()
    if not id then
      error("Not a valid LeetCode file. Expected format: {id}.{name}.{langtype}")
    end

    return {
      cmd = { "leetcode", "test", id },
      components = {
        { "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
        { "display_duration", detail_level = 2 },
        "default",
      },
    }
  end,
  condition = {
    callback = function()
      local filename = vim.fn.expand("%:t")
      -- Check if filename starts with a number (LeetCode file pattern)
      return filename:match("^%d+%.") ~= nil
    end,
  },
  priority = 50,
  tags = { overseer.TAG.TEST },
}
