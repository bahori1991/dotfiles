-- =====================================================================================================
-- TITLE: mfussenegger/nvim-lint
-- ABOUT: Asynchronous linter plugin for Neovim
-- LINKS: https://github.com/mfussenegger/nvim-lint
-- =====================================================================================================

local env = require("config.lsp-env")
local oxc = require("config.viteplus-oxc")
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  cond = env.typescript_lsp_available,
  config = function()
    local lint = require("lint")
    local function viteplus_oxlint(bufnr)
      local root = oxc.project_root(bufnr)
      local bin = oxc.resolve_ox_tool(root, "oxlint")
      if not bin then
        return nil, nil
      end
      return root, bin
    end
    lint.linters_by_ft = {
      javascript = { "oxlint" },
      javascriptreact = { "oxlint" },
      typescript = { "oxlint" },
      typescriptreact = { "oxlint" },
    }
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      callback = function(args)
        local bufnr = args.buf
        local root, bin = viteplus_oxlint(bufnr)
        if not root then
          return
        end
        lint.try_lint(nil, {
          cwd = root,
          wrap_linter = function(linter)
            linter.cmd = bin
            linter.args = vim.list_extend(oxc.vite_config_args(root), { "--format", "github" })
            return linter
          end,
        })
      end,
    })
  end,
}
