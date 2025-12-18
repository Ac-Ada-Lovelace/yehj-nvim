-- 过滤掉特定的 LSP 错误消息

-- 原始的 vim.notify
local original_notify = vim.notify

-- 覆盖 vim.notify 来过滤 OmniSharp 错误
vim.notify = function(msg, level, opts)
  -- 过滤 OmniSharp submission 错误
  if type(msg) == "string" and msg:match("Submission can only include script code") then
    return -- 静默忽略
  end

  -- 调用原始 notify
  original_notify(msg, level, opts)
end
