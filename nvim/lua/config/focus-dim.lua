-- ================================================================================
-- TITLE: focus-dim.lua
-- ABOUT: Gray out Neovim UI when the tmux pane loses focus
-- ================================================================================

if not vim.env.TMUX then
  return
end

local colors = require("config.colors")

local HL_GROUPS = {
  "Normal",
  "NormalNC",
  "CursorLine",
  "CursorLineNr",
  "LineNr",
  "WinBar",
  "WinBarNC",
  "SignColumn",
}

local cached_hl = {}
local is_dimmed = false

local function dim()
  if is_dimmed then
    return
  end

  for _, group in ipairs(HL_GROUPS) do
    cached_hl[group] = vim.api.nvim_get_hl(0, { name = group, link = false })
  end

  vim.api.nvim_set_hl(0, "Normal", { bg = colors.pane_inactive_bg, fg = colors.pane_inactive_fg })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = colors.pane_inactive_bg, fg = colors.pane_inactive_fg })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.pane_inactive_bg })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = colors.pane_inactive_bg, fg = colors.gray })
  vim.api.nvim_set_hl(0, "LineNr", { fg = colors.gray })
  vim.api.nvim_set_hl(0, "WinBar", { bg = colors.pane_inactive_bg, fg = colors.gray })
  vim.api.nvim_set_hl(0, "WinBarNC", { bg = colors.pane_inactive_bg, fg = colors.gray })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = colors.pane_inactive_bg })

  is_dimmed = true
end

local function restore()
  if not is_dimmed then
    return
  end

  for _, group in ipairs(HL_GROUPS) do
    local hl = cached_hl[group]
    if hl then
      vim.api.nvim_set_hl(0, group, hl)
    end
  end

  is_dimmed = false
end

vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
  callback = restore,
})

vim.api.nvim_create_autocmd({ "FocusLost", "VimSuspend" }, {
  callback = dim,
})

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    if vim.fn.has("focus") == 1 then
      restore()
    else
      dim()
    end
  end,
})
