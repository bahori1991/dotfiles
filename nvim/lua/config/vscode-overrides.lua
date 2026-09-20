-- =====================================================================================================
-- TITLE: vscode-overrides
-- ABOUT: color_overriddes / group_overrides for mofiqul/vscode.nvim
-- =====================================================================================================

local M = {}

M.color_overrides = {
  vscBack = "#121212",
  vscTabCurrent = "#121212",
  vscGreen = "#7cb668",
}

---@param c table vscode.colors palette from get_colors()
function M.build_group_overrides(c)
  return {
    NormalNC = { bg = c.vscTabOther, fg = c.vscFront },
    LineNr = { bg = c.vscBack, fg = c.vscLineNumber },
    LineNrNC = { bg = c.vscTabOther, fg = c.vscLineNumber },
    CursorLine = { bg = c.vscLeftMid },
    CursorLineNC = { bg = c.vscTabOther },
    CursorLineNr = { bg = c.vscBack, fg = c.vscPopupFront },
    CursorLineNrNC = { bg = c.vscTabOther, fg = c.vscPopupFront },

    Folded = { bg = c.vscBack, fg = c.vscLineNumber },

    SignColumn = { bg = c.vscBack, fg = "NONE" },
    SignColumnNC = { bg = c.vscTabOther, fg = "NONE" },
    BlinkCmpMenu = { fg = c.vscFront, bg = c.vscLeftMid },
    BlinkCmpMenuSelection = {
      fg = c.vscPopupFront,
      bg = c.vscPopupHighlightBlue,
    },
    WinBar = { bg = c.vscBack, fg = c.vscFront },
    WinBarNC = { bg = c.vscTabOther, fg = c.vscFront },

    BlinkPairsUnmatched = { fg = c.vscRed, bold = true },
    BlinkPairsMatchParen = { fg = c.vscOrange, bold = true },

    NormalFloat = { fg = c.vscFront, bg = c.vscPopupBack },
    FloatBorder = { fg = c.vscBlue, bg = c.vscPopupBack },
    LspFloatWinNormal = { fg = c.vscFront, bg = c.vscLeftMid },
    LspFloatWinBorder = { fg = c.vscSplitLight, bg = c.vscLeftMid },
    Pmenu = { fg = c.vscPopupFront, bg = c.vscLeftMid },
    PmenuSel = { fg = c.vscPopupFront, bg = c.vscPopupHighlightBlue },

    TelescopePromptNormal = { fg = c.vscFront, bg = c.vscBack },
    TelescopePromptBorder = { fg = c.vscBlue, bg = c.vscBack },
    TelescopePromptPrefix = { fg = c.vscSplitLight, bg = c.vscBack },
    TelescopePromptTitle = { fg = c.vscFront, bg = c.vscBack },
    TelescopeResultsNormal = { fg = c.vscFront, bg = c.vscBack },
    TelescopeResultsBorder = { fg = c.vscBlue, bg = c.vscBack },
    TelescopeResultsTitle = { fg = c.vscFront, bg = c.vscBack },
    TelescopePreviewNormal = { fg = c.vscFront, bg = c.vscBack },
    TelescopePreviewBorder = { fg = c.vscBlue, bg = c.vscBack },
    TelescopePreviewTitle = { fg = c.vscFront, bg = c.vscBack },
    TelescopeSelection = { fg = c.vscPopupFront, bg = c.vscPopupHighlightBlue },
    TelescopeMatching = { fg = c.vscBlue, bold = true },

    VirtColumn = { fg = c.vscBlue },
  }
end

---@param c table vscode.colors palette from get_colors()
function M.build_lualine_theme(c)
  local bg = c.vscLeftDark
  local bg2 = c.vscLeftMid
  local fg_dim = c.vscPopupFront
  local function section(mode_bg)
    return {
      a = { fg = c.vscBack, bg = mode_bg, gui = "bold" },
      b = { fg = mode_bg, bg = bg2 },
      c = { fg = fg_dim, bg = bg },
      x = { fg = fg_dim, bg = bg },
      y = { fg = fg_dim, bg = bg2 },
      z = { fg = c.vscBack, bg = mode_bg },
    }
  end
  return {
    normal = section(c.vscBlue),
    insert = section(c.vscGreen),
    visual = section(c.vscOrange),
    visual_line = section(c.vscOrange),
    visual_block = section(c.vscOrange),
    replace = section(c.vscPink),
    replace_char = section(c.vscPink),
    command = section(c.vscYellow),
    terminal = section(c.vscYellow),
    inactive = {
      a = { fg = fg_dim, bg = bg, gui = "bold" },
      b = { fg = fg_dim, bg = bg },
      c = { fg = fg_dim, bg = bg },
      x = { fg = fg_dim, bg = bg },
      y = { fg = fg_dim, bg = bg },
      z = { fg = fg_dim, bg = bg },
    },
  }
end

return M
