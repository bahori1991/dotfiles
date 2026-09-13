-- =====================================================================================================
-- TITLE: pmizio/typescript-tools.nvim
-- ABOUT: Blazingly fast typescript-language-server
-- LINKS: https://github.com/pmizio/typescript-tools.nvim
-- =====================================================================================================

local env = require("config.lsp-env")
return {
  "pmizio/typescript-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  ft = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
  cond = env.typescript_lsp_available,
  opts = {},
}
