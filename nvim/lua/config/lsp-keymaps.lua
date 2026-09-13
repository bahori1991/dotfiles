-- =====================================================================================================
-- TITLE: lsp-keymaps
-- ABOUT: set keymaps of LSP
-- =====================================================================================================

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
	callback = function(args)
		local map = function(mode, keys, fn, desc)
			vim.keymap.set(mode, keys, fn, { buffer = args.buf, desc = desc })
		end
		map("n", "gd", vim.lsp.buf.definition, "Go to Definition (LSP)")
		map("n", "K", vim.lsp.buf.hover, "Hover Docs (LSP)")
		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename variables or functions (LSP)")
		map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action (LSP)")
	end,
})
