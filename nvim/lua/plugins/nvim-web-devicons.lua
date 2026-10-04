-- =====================================================================================================
-- TITLE: nvim-tree/nvim-web-devicons
-- ABOUT: Provides Nerd Font icons (glyphs) for use by Neovim plugins
-- LINKS: https://github.com/nvim-tree/nvim-web-devicons
-- =====================================================================================================

return {
  "nvim-tree/nvim-web-devicons",
  lazy = false,
  priority = 1000,
  config = function()
    require("nvim-web-devicons").setup({
      override_by_filename = {
        ["package.json"] = {
          icon = "",
          color = "#339933",
          cterm_color = "28",
          name = "PackageJson",
        },
        ["package-lock.json"] = {
          icon = "",
          color = "#339933",
          cterm_color = "28",
          name = "PackageJson",
        },
      },
    })
  end,
}
