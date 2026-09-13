-- =====================================================================================================
-- TITLE: saghen/blink.pairs
-- ABOUT: Intelligent auto-pairs with rainbow highlighting for Neovim
-- LINKS: https://github.com/saghen/blink.pairs
-- =====================================================================================================

return {
  "saghen/blink.pairs",
  dependencies = { "saghen/blink.lib" },
  version = "*",
  event = { "InsertEnter", "CmdLineEnter" },
  build = function()
    require("blink.pairs").download():pwait(60000)
  end,
  opts = {
    mappings = {
      enabled = true,
      cmdline = true,
      disabled_filetypes = {},
      wrap = {
        ["<C-b>"] = "motion",
        ["<C-S-b>"] = "motion_reverse",
      },
      pairs = {},
    },
    highlights = {
      enabled = true,
      cmdline = true,
      groups = {
        "BlinkPairsBlue",
        "BlinkPairsYellow",
        "BlinkPairsGreen",
        "BlinkPairsOrange",
      },
      unmatched_group = "BlinkPairsUnmatched",
      matchparen = {
        enabled = true,
        cmdline = false,
        include_surrounding = false,
        group = "BlinkPairsMatchParen",
      },
    },
    debug = false,
  },
}
