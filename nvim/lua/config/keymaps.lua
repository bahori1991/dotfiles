-- =====================================================================================================
-- TITLE: keymaps
-- ABOUT: set keymaps of Neovim
-- =====================================================================================================

-- leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- disable up/down/left/right
vim.keymap.set({ "n", "i", "v" }, "<Up>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "n", "i", "v" }, "<Down>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "n", "i", "v" }, "<Left>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "n", "i", "v" }, "<Right>", "<Nop>", { noremap = true, silent = true })

-- move current row to center
vim.keymap.set("n", "G", "Gzt", { noremap = true, silent = true })

-- Redraw Neovim window
vim.keymap.set("n", "<leader>l", "<cmd>nohlsearch<bar>redraw!<cr>", {
  desc = "Redraw / clear search highlight",
})

-- move to end of word after uppercased
vim.keymap.set("n", "gUiw", "gUiwe", { noremap = true })

-- toggle file explorer whether
local explorer = require("config.explorer")

vim.keymap.set("n", "<leader>e", explorer.toggle, { desc = "Toggle File/Solution Explorer" })
