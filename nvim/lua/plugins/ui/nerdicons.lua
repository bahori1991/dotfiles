-- ================================================================================
-- TITLE: nvimdev/nerdicons.nvim
-- ABOUT: Get the Nerdfont icons inside Neovim.
-- LINKS: https://github.com/nvimdev/nerdicons.nvim
-- ================================================================================

return {
  "nvimdev/nerdicons.nvim",
  cmd = "NerdIcons",
  opts = {},
  keys = {
    { "<leader>ni", "<cmd>NerdIcons<cr>", desc = "Icons: add", mode = "n" },
  },
}
