-- =====================================================================================================
-- TITLE: WhoIsSethDaniel/mason-tool-installer.nvim
-- ABOUT: Ensure Mason tools are installed/updated on startup
-- LINKS: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
-- =====================================================================================================

local env = require("config.lsp-env")
local ensure_installed = {
  "lua_ls",
  "stylua",
}
if env.roslyn_lsp_available() then
  table.insert(ensure_installed, "roslyn")
end

if env.typescript_lsp_available() then
  table.insert(ensure_installed, "oxfmt")
  table.insert(ensure_installed, "oxlint")
end

return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  opts = {
    ensure_installed = ensure_installed,
    run_on_start = true,
    start_delay = 1000,
    debounce_hours = 24,
    integrations = {
      ["mason-lspconfig"] = true,
      ["mason-null-ls"] = false,
      ["mason-nvim-dap"] = false,
    },
  },
}
