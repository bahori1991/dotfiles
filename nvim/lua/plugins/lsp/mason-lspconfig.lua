-- ======================================================================================
-- TITLE: mason-org/mason-lspconfig.nvim
-- ABOUT: bridges mason.nvim with the lspconfig plugin
-- LINKS: https://github.com/mason-org/mason-lspconfig.nvim
-- ======================================================================================

return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  opts = {
    automatic_enable = false
  },
}
