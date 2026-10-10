-- =====================================================================================================
-- TITLE: treesitter-highlight
-- ABOUT: Set highlight enable
-- =====================================================================================================

vim.treesitter.language.register("tsx", "typescriptreact")
vim.treesitter.language.register("jsx", "javascriptreact")

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local ft = args.match
    if ft == "" then
      return
    end
    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then
      return
    end
    local ok = vim.treesitter.language.add(lang)
    if not ok then
      return
    end
    vim.treesitter.start(args.buf, lang)
  end,
})
