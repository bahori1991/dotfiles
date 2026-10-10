-- =====================================================================================================
-- TITLE: focus-dim.lua
-- ABOUT: Dim UI when Neovim loses application focus
-- =====================================================================================================

vim.g.nvim_focused = true

local active_wh = table.concat({
  "Normal:Normal",
  "LineNr:LineNr",
  "CursorLineNr:CursorLineNr",
  "SignColumn:SignColumn",
  "CursorLine:CursorLine",
  "WinBar:WinBar",
}, ",")

local inactive_wh = table.concat({
  "Normal:NormalNC",
  "LineNr:LineNrNC",
  "CursorLineNr:CursorLineNrNC",
  "SignColumn:SignColumnNC",
  "CursorLine:CursorLineNC",
  "WinBar:WinBarNC",
  "EndOfBuffer:EndOfBufferNC",
}, ",")

local tree_bg_only = {
  "NvimTreeStatusLine",
  "NvimTreeStatusLineNC",
}
local tree_bg_sync = {
  "NvimTreeFolderName",
  "NvimTreeOpenedFolderName",
  "NvimTreeEmptyFolderName",
  "NvimTreeRootFolder",
  "NvimTreeIndentMarker",
}

local function is_nvim_tree_win(win)
  local buf = vim.api.nvim_win_get_buf(win)
  return vim.bo[buf].filetype == "NvimTree"
end

local function winhighlight_str(active)
  return active and active_wh or inactive_wh
end

local function set_winhighlight(win, active)
  vim.wo[win].winhighlight = winhighlight_str(active)
end

local function set_all_winhighlights(active)
  local wh = winhighlight_str(active)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    vim.wo[win].winhighlight = wh
  end
end

local function sync_winhighlights()
  if not vim.g.nvim_focused then
    set_all_winhighlights(false)
    return
  end
  local current = vim.api.nvim_get_current_win()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local active = win == current or is_nvim_tree_win(win)
    set_winhighlight(win, active)
  end
end

local function set_pane_hl(focused)
  local c = require("vscode.colors").get_colors()
  local bg = focused and c.vscBack or c.vscTabOther
  vim.api.nvim_set_hl(0, "Normal", { bg = bg, fg = c.vscFront })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = focused and c.vscLeftMid or c.vscTabOther })
  vim.api.nvim_set_hl(0, "LineNr", { bg = bg, fg = c.vscLineNumber })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = bg, fg = c.vscPopupFront })
  vim.api.nvim_set_hl(0, "SignColumn", { fg = "NONE", bg = bg })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = bg, fg = bg })
  if focused then
    vim.api.nvim_set_hl(0, "WinBar", { bg = bg, fg = c.vscFront })
    vim.api.nvim_set_hl(0, "WinBarNC", { bg = c.vscTabOther, fg = c.vscFront })
  else
    vim.api.nvim_set_hl(0, "WinBar", { bg = bg, fg = c.vscFront })
    vim.api.nvim_set_hl(0, "WinBarNC", { bg = bg, fg = c.vscFront })
  end
end

local function set_tree_hl(focused)
  local c = require("vscode.colors").get_colors()
  local bg = focused and c.vscBack or c.vscTabOther
  local cl = focused and c.vscLeftMid or c.vscTabOther
  vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = bg, fg = c.vscFront })
  vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = bg, fg = c.vscFront })
  vim.api.nvim_set_hl(0, "NvimTreeSignColumn", { bg = bg, fg = "NONE" })
  vim.api.nvim_set_hl(0, "NvimTreeLineNr", { bg = bg, fg = c.vscLineNumber })
  vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = cl })
  vim.api.nvim_set_hl(0, "NvimTreeCursorLineNr", { bg = bg, fg = c.vscPopupFront })
  vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", {
    bg = bg,
    fg = focused and c.vscSplitDark or c.vscTabOther,
  })
  vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = bg, fg = bg })
  for _, group in ipairs(tree_bg_only) do
    vim.api.nvim_set_hl(0, group, { bg = bg, fg = "NONE" })
  end
  for _, group in ipairs(tree_bg_sync) do
    vim.api.nvim_set_hl(0, group, { bg = bg, default = true })
  end
end

local function apply_focus_state(focused)
  vim.g.nvim_focused = focused
  set_pane_hl(focused)
  set_tree_hl(focused)
  if focused then
    sync_winhighlights()
  else
    set_all_winhighlights(false)
  end
end

local function sync_tree_buf()
  set_tree_hl(vim.g.nvim_focused)
  vim.schedule(function()
    sync_winhighlights()
  end)
end

local focus_au = vim.api.nvim_create_augroup("FocusDim", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = focus_au,
  once = true,
  callback = function()
    apply_focus_state(true)
  end,
})

vim.api.nvim_create_autocmd("FocusGained", {
  group = focus_au,
  callback = function()
    apply_focus_state(true)
  end,
})

vim.api.nvim_create_autocmd("FocusLost", {
  group = focus_au,
  callback = function()
    apply_focus_state(false)
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  group = focus_au,
  callback = function()
    sync_winhighlights()
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  group = focus_au,
  callback = function()
    if not vim.g.nvim_focused then
      set_winhighlight(0, false)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = focus_au,
  pattern = "NvimTree",
  callback = function()
    sync_tree_buf()
  end,
})
