-- =====================================================================================================
-- TITLE: keymaps
-- ABOUT: set keymaps of Neovim
-- =====================================================================================================

-- move current row to center
vim.keymap.set("n", "G", "Gzz", { noremap = true, silent = true })
vim.keymap.set("n", "n", "nzzzv", { noremap = true, silent = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true, silent = true })

-- Redraw Neovim window
vim.keymap.set("n", "<leader>l", "<cmd>nohlsearch<bar>redraw!<cr>", {
  desc = "Redraw / clear search highlight",
})

-- move to end of word after uppercased
vim.keymap.set("n", "gUiw", "gUiwe", { noremap = true })
