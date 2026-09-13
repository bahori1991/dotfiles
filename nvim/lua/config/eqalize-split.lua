-- =====================================================================================================
-- TITLE: equalize-split.lua
-- ABOUT: Balance layout after prefix + z
-- =====================================================================================================

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("eqalize_splits", { clear = true }),
  callback = function()
    local tab = vim.fn.tabpagenr()
    vim.cmd.tabdo("wincmd =")
    vim.cmd.tabnext(tab)
  end,
})

