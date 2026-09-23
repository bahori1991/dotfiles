-- =====================================================================================================
-- TITLE: focus-dim.lua
-- ABOUT: Change background-color on focus
-- =====================================================================================================

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
}, ",")

vim.api.nvim_create_autocmd({ "WinEnter", "VimEnter" }, {
  callback = function()
    vim.wo.winhighlight = active_wh
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    vim.wo.winhighlight = inactive_wh
  end,
})

local c = require("vscode.colors").get_colors()

local function set_pane_focus(focused)
  local bg = focused and c.vscBack or c.vscTabOther
  vim.api.nvim_set_hl(0, "Normal", { bg = bg, fg = c.vscFront })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = focused and c.vscLeftMid or c.vscTabOther })
  vim.api.nvim_set_hl(0, "LineNr", { bg = bg, fg = c.vscLineNumber })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = bg, fg = c.vscPopupFront })
  vim.api.nvim_set_hl(0, "SignColumn", { fg = "NONE", bg = bg })
  vim.api.nvim_set_hl(0, "WinBar", { bg = bg, fg = c.vscFront })
  vim.api.nvim_set_hl(0, "WinBarNC", { bg = bg, fg = c.vscFront })
end

local function set_tree_focus(focused)
  local bg = focused and c.vscBack or c.vscTabOther
  local cl = focused and c.vscLeftMid or c.vscTabOther
  vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = bg, fg = c.vscFront })
  vim.api.nvim_set_hl(0, "NvimTreeSignColumn", { bg = bg, fg = "NONE" })
  vim.api.nvim_set_hl(0, "NvimTreeLineNr", { bg = bg, fg = c.vscLineNumber })
  vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = cl })
  vim.api.nvim_set_hl(0, "NvimTreeCursorLineNr", { bg = bg, fg = c.vscPopupFront })
end

vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    vim.g.nvim_focused = true
    set_pane_focus(true)
    set_tree_focus(true)
  end,
})

vim.api.nvim_create_autocmd("FocusLost", {
  callback = function()
    vim.g.nvim_focused = false
    set_pane_focus(false)
    set_tree_focus(false)
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.g.nvim_focused = true
    set_pane_focus(true)
    set_tree_focus(true)
  end,
})
