-- =====================================================================================================
-- TITLE: nvim-treesitter/nvim-treesitter
-- ABOUT: Manage parse and query
-- LINKS: https://github.com/nvim-treesitter/nvim-treesitter
-- =====================================================================================================

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })
    local parsers = {
      "lua",
      "markdown",
      "markdown_inline",
      "bash",
      "json",
      "yaml",
      "javascript",
      "typescript",
      "tsx",
      "jsx",
      "c_sharp",
      "vim",
      "vimdoc",
      "query",
    }
    require("nvim-treesitter").install(parsers)
  end,
}
