-- ================================================================================
-- TITLE: mofiqul/vscode.nvim
-- ABOUT: VSCode like color scheme for Neovim
-- LINKS: https://github.com/mofiqul/vscode.nvim
-- ================================================================================

local colors = require("config.colors")
return {
  "Mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,
  opts = {
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
      -- general floating windows (LSP hover, diagnostics, etc.)
      NormalFloat = { bg = colors.bg_float },
      FloatBorder = { bg = colors.bg_float, fg = colors.border },
      -- cursor
      vCursor = { bg = colors.orange },
      -- cursor line
      CursorLine = { bg = colors.bg_select },
      -- dropbar
      WinBar = { bg = colors.bg_select },
      WinBarNC = { bg = colors.bg_select },
    },
  },
  config = function(_, opts)
    require("vscode").setup(opts)
    vim.cmd([[colorscheme vscode]])
  end,
}
