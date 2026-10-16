-- =====================================================================================================
-- TITLE: stevearc/conform.nvim
-- ABOUT: Lightweight formatter plugin for Neovim
-- LINKS: https://github.com/stevearc/conform.nvim
-- =====================================================================================================

local env = require("config.lsp-env")
local oxc = require("config.viteplus-oxc")

local function lint_error_count(bufnr, opts)
  opts = opts or {}
  local only_source = opts.source
  local n = 0
  for _, d in ipairs(vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })) do
    if not only_source or d.source == only_source then
      n = n + 1
    end
  end
  return n
end

local function conform_notify(msg, level)
  vim.notify(msg, level, { title = "Conform" })
end

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
      lsp_format = false,
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      local err_count = lint_error_count(bufnr)
      if err_count > 0 then
        conform_notify(string.format("Skipped format: %d linter error(s) on buffer", err_count), vim.log.levels.WARN)
        return
      end
      local conform = require("conform")
      local formatters = conform.list_formatters(bufnr)
      if #formatters == 0 then
        return
      end
      local formatter_names = vim.tbl_map(function(f)
        return f.name
      end, formatters)
      local opts = { timeout_ms = 2000, lsp_format = false }
      local callback = function(err, did_edit)
        if err then
          conform_notify(err.message or "Format failed", vim.log.levels.ERROR)
          return
        end
        if did_edit then
          conform_notify("Formatted: " .. table.concat(formatter_names, ", "), vim.log.levels.INFO)
          return
        end
      end
      return opts, callback
    end,
    formatters = {
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
      oxfmt = {
        command = function(_, ctx)
          local root = oxc.project_root(ctx.buf)
          return oxc.resolve_ox_tool(root, "oxfmt") or "oxfmt"
        end,
        args = { "--stdin-filepath", "$FILENAME" },
        cwd = function(_, ctx)
          return oxc.project_root(ctx.buf)
        end,
        condition = function(_, ctx)
          if not env.typescript_lsp_available() then
            return false
          end
          local root = oxc.project_root(ctx.buf)
          return oxc.resolve_ox_tool(root, "oxfmt") ~= nil
        end,
      },
      dotnet_format = {
        command = "dotnet",
        args = { "format", "--include", "$FILENAME" },
        stdin = false,
        cwd = function(_, ctx)
          return require("conform.util").root_file({ "*.sln", "*.slnx", "*.csproj" })(_, ctx)
        end,
        require_cwd = true,
        condition = function()
          return env.dotnet_lsp_available()
        end,
      },
    },
    notify_on_error = true,
  },
}
