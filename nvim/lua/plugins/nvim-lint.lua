-- =====================================================================================================
-- TITLE: mfussenegger/nvim-lint
-- ABOUT: Asynchronous linter plugin for Neovim
-- LINKS: https://github.com/mfussenegger/nvim-lint
-- =====================================================================================================

local env = require("config.lsp-env")
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  cond = env.typescript_lsp_available,
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      javascript = { "oxlint" },
      javascriptreact = { "oxlint" },
      typescript = { "oxlint" },
      typescriptreact = { "oxlint" },
    }
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
