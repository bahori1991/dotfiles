-- =====================================================================================================
-- TITLE: kkoomen/vim-doge
-- ABOUT: Generate documentation comments for functions, classes, etc...
-- LINKS: https://github.com/kkoomen/vim-doge
-- =====================================================================================================

return {
  "kkoomen/vim-doge",
  build = ":call doge#install()",
  ft = {
    "lua",
    "javascript",
    "typescript",
    "tsx",
    "jsx",
    "cs",
  },
  init = function()
    vim.g.doge_enable_mappings = 0
    vim.g.doge_doc_standard_lua = "ldoc"
    vim.g.doge_doc_standard_javascript = "jsdoc"
    vim.g.doge_doc_standard_typescript = "jsdoc"
    vim.g.doge_doc_standard_cs = "xmldoc"
  end,
  config = function()
    vim.keymap.set("n", "<leader>cd", "<cmd>DogeGenerate<cr>", {
      desc = "Generate doc comment (vim-doge)",
      silent = true,
    })
  end,
}
