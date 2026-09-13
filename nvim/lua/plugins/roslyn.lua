-- =====================================================================================================
-- TITLE: seblyng/roslyn.nvim
-- ABOUT: C# Roslyn language server
-- LINKS: https://github.com/seblyng/roslyn.nvim
-- =====================================================================================================

local env = require("config.lsp-env")
return {
  "seblyng/roslyn.nvim",
  ft = { "cs", "razor" },
  cond = env.roslyn_lsp_available,
  opts = {},
}
