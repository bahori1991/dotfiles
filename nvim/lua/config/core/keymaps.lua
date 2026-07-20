-- ================================================================================
-- TITLE: keymaps.lua
-- ABOUT: Configure global keymaps for Neovim (buffer-local LSP maps: config/lsp/lsp.lua)
-- ================================================================================

local noop = { noremap = true, silent = true }

-- Disable Arrow keys in Neovim
vim.keymap.set({ "n", "i", "v", "c" }, "<Up>", "<Nop>", noop)
vim.keymap.set({ "n", "i", "v", "c" }, "<Down>", "<Nop>", noop)
vim.keymap.set({ "n", "i", "v", "c" }, "<Left>", "<Nop>", noop)
vim.keymap.set({ "n", "i", "v", "c" }, "<Right>", "<Nop>", noop)

-- Disable keymaps
vim.keymap.del("n", "gcc")

-- Diagnostics
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Diagnostic: previous" })

vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Diagnostic: next" })

vim.keymap.set("n", "<leader>d", function()
	vim.diagnostic.open_float()
end, { desc = "Diagnostic: float" })

-- inlayHint
vim.keymap.set("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle inlay Hints" })
