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

vim.keymap.set("n", "<leader>y", function()
	local line = vim.api.nvim_win_get_cursor(0)[1] - 1
	local diags = vim.diagnostic.get(0, { lnum = line })
	if #diags == 0 then
		vim.notify("No diagnostic at cursor", vim.log.levels.WARN)
		return
	end

	table.sort(diags, function(a, b)
		return a.severity < b.severity
	end)

	local d = diags[1]
	local text = d.message
	if d.source then
		text = ("[%s] %s"):format(d.source, text)
	end
	if d.code then
		text = text .. " (" .. tostring(d.code) .. ")"
	end

	vim.fn.setreg("+", text)
	vim.notify("Copied diagnostic", vim.log.levels.INFO)
end, { desc = "Diagnostic: copy message" })

-- inlayHint
vim.keymap.set("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle inlay Hints" })

-- comment auto-insert (formatoptions r/o)
vim.keymap.set("n", "<leader>ci", function()
	require("config.core.comment-auto-insert").toggle()
end, { desc = "Toggle comment auto-insert" })

-- Message history in a floating window
vim.keymap.set("n", "<leader>fm", function()
	require("config.ui.messages").show()
end, { desc = "Show message history" })
