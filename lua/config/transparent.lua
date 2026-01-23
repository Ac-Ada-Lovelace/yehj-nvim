local function apply_transparent()
  local groups = {
    "Normal",
    "NormalNC",
    "SignColumn",
    "EndOfBuffer",

    "MsgArea",
    "ModeMsg",

    "WinSeparator",
    "VertSplit",

    "TabLine",
    "TabLineFill",
    "TabLineSel",

    "Pmenu",
    "PmenuSel",
    "PmenuSbar",
    "PmenuThumb",

    "PmenuExtra",
    "PmenuKind",

    "NormalFloat",
    "FloatBorder",

    "CmpPmenu",
    "CmpPmenuSel",
    "CmpPmenuBorder",
    "CmpPmenuThumb",
    "CmpPmenuSbar",

    "Pmenu",
    "BlinkCmpMenu",
    "BlinkCmpMenuBorder",
    "BlinkCmpDoc",

    "BlinkCmpDocBorder",
    "BlinkCmpDocSeparator",
    "BlinkCmpSignatureHelp",
    "BlinkCmpSignatureHelpBorder",

    "NoiceCmdlinePopup",
    "NoicePopupmenu",
    "NoicePopupmenuMatch",
    "NoicePopupmenuSelected",

    "WhichKey",
    "WhichKeyBorder",
    "WhichKeyFloat",
    "WhichKeyDesc",
    "WhichKeyGroup",
    "WhichKeySeparator",
    "WhichKeyValue",
    "WhichKeyNormal",
    "WhichKeyTitle",
  }
  vim.api.nvim_set_hl(0, "LspInlayHint", {
    fg = "#8aa2b6", -- 轻一点的对比色，可按主题调整
    bg = "NONE",
    italic = true,
  })
  -- Lualine uses its own highlight groups per mode/section.
  -- local lualine_sections = { "a", "b", "c", "x", "y", "z" }
  -- local lualine_modes = { "normal", "insert", "visual", "replace", "command", "inactive", "terminal" }
  -- for _, mode in ipairs(lualine_modes) do
  --   for _, section in ipairs(lualine_sections) do
  --     table.insert(groups, "lualine_" .. section .. "_" .. mode)
  --   end
  -- end
  --
  -- Include notify highlight groups if they exist.
  for _, group in ipairs(vim.fn.getcompletion("Notify", "highlight")) do
    table.insert(groups, group)
  end
  -- Include snacks notifier highlight groups if they exist.
  for _, group in ipairs(vim.fn.getcompletion("SnacksNotifier", "highlight")) do
    table.insert(groups, group)
  end
  -- Explicit notify groups in case they are created later.
  local notify_groups = {
    "NotifyBackground",
    "NotifyERRORBody",
    "NotifyERRORBorder",
    "NotifyERRORTitle",
    "NotifyWARNBody",
    "NotifyWARNBorder",
    "NotifyWARNTitle",
    "NotifyINFOBody",
    "NotifyINFOBorder",
    "NotifyINFOTitle",
    "NotifyDEBUGBody",
    "NotifyDEBUGBorder",
    "NotifyDEBUGTitle",
    "NotifyTRACEBody",
    "NotifyTRACEBorder",
    "NotifyTRACETitle",
  }
  for _, group in ipairs(notify_groups) do
    table.insert(groups, group)
  end
  -- Explicit snacks notifier groups used in winhighlight.
  local snacks_notify_groups = {
    "SnacksNotifier",
    "SnacksNotifierHistory",
    "SnacksNotifierHistoryTitle",
    "SnacksNotifierHistoryDateTime",
    "SnacksNotifierMinimal",
    "SnacksNotifierIconInfo",
    "SnacksNotifierTitleInfo",
    "SnacksNotifierBorderInfo",
    "SnacksNotifierFooterInfo",
    "SnacksNotifierInfo",
    "SnacksNotifierIconWarn",
    "SnacksNotifierTitleWarn",
    "SnacksNotifierBorderWarn",
    "SnacksNotifierFooterWarn",
    "SnacksNotifierWarn",
    "SnacksNotifierIconError",
    "SnacksNotifierTitleError",
    "SnacksNotifierBorderError",
    "SnacksNotifierFooterError",
    "SnacksNotifierError",
    "SnacksNotifierIconDebug",
    "SnacksNotifierTitleDebug",
    "SnacksNotifierBorderDebug",
    "SnacksNotifierFooterDebug",
    "SnacksNotifierDebug",
    "SnacksNotifierIconTrace",
    "SnacksNotifierTitleTrace",
    "SnacksNotifierBorderTrace",
    "SnacksNotifierFooterTrace",
    "SnacksNotifierTrace",
  }
  for _, group in ipairs(snacks_notify_groups) do
    table.insert(groups, group)
  end

  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end

  -- Keep completion menus transparent, but make the active item readable.
  vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
  vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2a323c" })
  vim.api.nvim_set_hl(0, "CmpPmenu", { bg = "none" })
  vim.api.nvim_set_hl(0, "CmpPmenuSel", { bg = "#2a323c" })
  vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "none" })
  -- vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = "#7aa2f7", bg = "none" })
  vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#2a323c" })
  vim.api.nvim_set_hl(0, "BlinkCmpMenuSel", { bg = "#2a323c" })

  -- Scrollbar visibility for popup menus/docs.
  vim.api.nvim_set_hl(0, "PmenuThumb", { fg = "#c8c8c8", bg = "none" })
  vim.api.nvim_set_hl(0, "PmenuSbar", { fg = "#5a5a5a", bg = "none" })
  vim.api.nvim_set_hl(0, "NoiceScrollbar", { fg = "#c8c8c8", bg = "none" })

  -- Set general FloatBorder with visible color

  -- Keep Snacks explorer/search input border opaque for visibility.
  vim.api.nvim_set_hl(0, "SnacksPickerInputBorder", { fg = "#4b5b6a", bg = "none" })
  vim.api.nvim_set_hl(0, "SnacksPickerInputTitle", { fg = "#4b5b6a", bg = "none" })

  -- Set Noice popupmenu border with explicit colors
  vim.api.nvim_set_hl(0, "NoicePopupmenuBorder", { fg = "#7aa2f7", bg = "none" })
end

apply_transparent()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_transparent,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = apply_transparent,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "notify",
  callback = apply_transparent,
})

return {}
