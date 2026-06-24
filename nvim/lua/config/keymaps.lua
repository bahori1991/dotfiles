-- ================================================================================
-- TITLE: keymaps.lua
-- ABOUT: Configure keymaps for Neovim
-- ================================================================================

-- Disable Arrow keys in Neovim
vim.keymap.set({ "n", "i", "v", "c" }, "<Up>", "<Nop>", { noremap = true })
vim.keymap.set({ "n", "i", "v", "c" }, "<Down>", "<Nop>", { noremap = true })
vim.keymap.set({ "n", "i", "v", "c" }, "<Left>", "<Nop>", { noremap = true })
vim.keymap.set({ "n", "i", "v", "c" }, "<Right>", "<Nop>", { noremap = true })
