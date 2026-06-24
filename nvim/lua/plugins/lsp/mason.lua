-- ======================================================================================
-- TITLE: mason-org/mason.nvim
-- ABOUT: Easy install and manage LSP servers, DAP servers, linters, and formatters
-- LINKS: https://github.com/mason-org/mason.nvim
-- ======================================================================================

return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
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
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      automatic_enable = false
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "stylua",
      },
    },
  },
}
