-- ================================================================================
-- TITLE: keymaps.lua
-- ABOUT: Configure keymaps for Neovim
-- ================================================================================

-- Disable Arrow keys in Neovim
vim.keymap.set({ "n", "i", "v", "c" }, "<Up>", "<Nop>", { noremap = true })
vim.keymap.set({ "n", "i", "v", "c" }, "<Down>", "<Nop>", { noremap = true })
vim.keymap.set({ "n", "i", "v", "c" }, "<Left>", "<Nop>", { noremap = true })
vim.keymap.set({ "n", "i", "v", "c" }, "<Right>", "<Nop>", { noremap = true })

-- Diagnostics
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Previous diagnostic" })

vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "<leader>o", vim.diagnostic.open_float, { desc = "Show diagnostic" })
