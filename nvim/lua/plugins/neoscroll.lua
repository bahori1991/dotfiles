-- =====================================================================================================
-- TITLE: karb94/neoscroll.nvim
-- ABOUT: Smooth scrolling Neovim plugin
-- LINKS: https://github.com/karb94/neoscroll.nvim
-- =====================================================================================================

return {
  "karb94/neoscroll.nvim",
  opts = {
    mappings = {
      "<C-u>",
      "<C-d>",
      "<C-b>",
      "<C-f>",
      "<C-y>",
      "<C-e>",
      "zt",
      "zz",
      "zb",
    },
    hide_cursor = true,
    stop_eof = false,
    respect_scrolloff = false,
    cursor_scrolls_alone = true,
    duration_multiplier = 0.8,
    easing = "quadratic",
    performance_mode = false,
  },
}
