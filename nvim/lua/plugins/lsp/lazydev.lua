-- ========================================================================================
-- TITLE: folke/lazydev.nvim
-- ABOUT: configure LuaLS for editing Neovim config by lazily updating workspace libraries.
-- LINKS: https://github.com/folke/lazydev.nvim
-- ========================================================================================

return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv", "uv%." } },
      { path = "nvim-tree.lua", words = { "nvim_tree" } },
    },
  },
}
