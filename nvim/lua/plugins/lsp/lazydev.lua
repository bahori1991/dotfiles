-- ========================================================================================
-- TITLE: folke/lazydev.nvim
-- ABOUT: configure LuaLS for editing Neovim config by lazily updating workspace libraries.
-- LINKS: https://github.com/folke/lazydev.nvim
-- ========================================================================================
--
-- lua_ls static settings (runtime, diagnostics, checkThirdParty) live in nvim-lspconfig.lua.
-- lazydev only augments workspace library paths for Lua buffers.

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
