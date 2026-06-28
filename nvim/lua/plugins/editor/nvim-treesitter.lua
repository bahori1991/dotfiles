-- ================================================================================
-- TITLE: neovim-treesitter/nvim-treesitter
-- ABOUT: manage parser and query
-- LINKS: https://github.com/neovim-treesitter/nvim-treesitter
-- ================================================================================

return {
  "neovim-treesitter/nvim-treesitter",
  dependencies = { "neovim-treesitter/treesitter-parser-registry" },
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local parsers = {
      "markdown",
      "markdown_inline",
      "html_tags",
      "html",
      "ecma",
      "typescript",
      "javascript",
      "tsx",
      "jsx",
      "css",
      "lua",
      "python",
      "yaml",
      "toml",
      "json",
    }
    local filetypes = {
      "markdown",
      "mdx",
      "html",
      "typescript",
      "typescriptreact",
      "javascript",
      "css",
      "lua",
      "python",
      "yaml",
      "toml",
      "json",
    }

    vim.api.nvim_create_user_command("TSInstallConfigured", function()
      require("nvim-treesitter").install(parsers)
    end, {})

    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function()
        pcall(vim.treesitter.start)
        vim.wo.foldexpr = "v:lua.nvim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
        vim.wo.foldlevel = 99
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
