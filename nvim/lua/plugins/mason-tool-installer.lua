-- =====================================================================================================
-- TITLE: WhoIsSethDaniel/mason-tool-installer.nvim
-- ABOUT: Ensure Mason tools are installed/updated on startup
-- LINKS: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
-- =====================================================================================================

local env = require("config.lsp-env")
local function build_ensure_installed()
  local list = {
    "lua_ls",
    "stylua",
  }
  if env.typescript_lsp_available() then
    table.insert(list, "oxfmt")
    table.insert(list, "oxlint")
  end
  return list
end

return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  opts = {
    ensure_installed = build_ensure_installed(),
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
