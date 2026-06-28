-- ========================================================================================
-- TITLE: WhoIsSethDaniel/mason-tool-installer.nvim
-- ABOUT: keep up to date with tools and to make consistent environment
-- LINKS: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
-- ========================================================================================

return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "mason-org/mason.nvim" },
  opts = {
    ensure_installed = {
      "lua_ls",
      "stylua",
    },
  },
}

