-- =====================================================================================================
-- TITLE: stevearc/conform.nvim
-- ABOUT: Lightweight formatter plugin for Neovim
-- LINKS: https://github.com/stevearc/conform.nvim
-- =====================================================================================================

local env = require("config.lsp-env")
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "oxfmt" },
      javascriptreact = { "oxfmt" },
      typescript = { "oxfmt" },
      typescriptreact = { "oxfmt" },
      json = { "oxfmt" },
      jsonc = { "oxfmt" },
      cs = { "dotnet_format" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    formatters = {
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
      oxfmt = {
        command = vim.fn.stdpath("data") .. "/mason/bin/oxfmt",
        condition = function()
          return env.typescript_lsp_available()
        end,
      },
      dotnet_format = {
        command = "dotnet",
        args = { "format", "--include", "$FILENAME" },
        stdin = false,
        cwd = function(ctx)
          return require("conform.util").root_file({ "*.sln", "*.slnx", "*.csproj" })(ctx)
        end,
        require_cwd = true,
        condition = function()
          return env.roslyn_lsp_available()
        end,
      },
    },
    notify_on_error = true,
  },
}
