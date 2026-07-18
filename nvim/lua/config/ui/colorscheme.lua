-- ================================================================================
-- TITLE: colorscheme.lua
-- ABOUT: Shared vscode colorscheme setup and restore
-- ================================================================================

local colors = require("config.ui.colors")

local M = {}

function M.vscode_opts()
  return {
    transparent = true,
    disable_nvimtree_bg = true,
    group_overrides = {
      -- blink.cmp
      BlinkCmpMenu = { bg = colors.bg_float },
      BlinkCmpMenuBorder = { bg = colors.bg_float, fg = colors.border },
      BlinkCmpMenuSelection = { bg = colors.bg_select, fg = colors.fg_muted },
      BlinkCmpDoc = { bg = colors.bg_float },
      BlinkCmpDocBorder = { bg = colors.bg_float, fg = colors.border },
      BlinkCmpSignatureHelp = { bg = colors.bg_float },
      BlinkCmpSignatureHelpBorder = { bg = colors.bg_float, fg = colors.border },
      -- blink.indent
      BlinkIndent = { fg = colors.gray },
      BlinkIndentBlue = { fg = colors.blue },
      -- blink.pairs
      BlinkPairsBlue = { fg = colors.blue },
      BlinkPairsUnmatched = { fg = colors.red },
      BlinkPairsUnmatchParen = { bg = colors.bg_select, bold = true },
      -- general floating windows (LSP hover, diagnostics, etc.)
      NormalFloat = { bg = colors.bg_float },
      FloatBorder = { bg = colors.bg_float, fg = colors.border },
      -- cursor
      vCursor = { bg = colors.orange },
      -- cursor line
      CursorLine = { bg = colors.bg_select },
      CursorLineNr = { bg = colors.bg_select, fg = colors.yellow, bold = true },
      -- nvim-tree (match editor cursor line)
      NvimTreeCursorLine = { bg = colors.bg_select },
      NvimTreeCursorLineNr = { bg = colors.bg_select, fg = colors.yellow, bold = true },
      -- dropbar
      WinBar = { bg = colors.bg_dropbar },
      WinBarNC = { bg = colors.bg_dropbar },
      -- Folded
      Folded = { fg = colors.gray },
    },
  }
end

function M.apply_vscode()
  require("vscode").setup(M.vscode_opts())
  require("vscode").load()
end

return M
