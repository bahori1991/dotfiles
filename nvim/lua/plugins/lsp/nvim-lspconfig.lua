-- ========================================================================================
-- TITLE: neovim/nvim-lspconfig
-- ABOUT: collection of LSP server configurations for the Neovim LSP client
-- LINKS: https://github.com/neovim/nvim-lspconfig
-- ========================================================================================

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp"
  },
  opts = {
    servers = {
      lua_ls = {},
    }
  },
  config = function(_, opts)
    for server, config in pairs(opts.servers) do
      config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
      vim.lsp.enable(server)
    end
  end,
}
