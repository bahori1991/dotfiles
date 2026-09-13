-- =====================================================================================================
-- TITLE: treesitter-highlight
-- ABOUT: Set highlight enable
-- =====================================================================================================

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then
      return
    end
    if vim.treesitter.language.add(lang) then
      vim.treesitter.start()
    end
  end,
})
