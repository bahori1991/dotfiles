-- ================================================================================
-- TITLE: config.lsp.lua
-- ABOUT: configulation file of LSP
-- ================================================================================

vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = false,
	float = {
		border = "rounded",
		source = "if_many",
	},
	underline = true,
	virtual_text = {
		spacing = 2,
		source = "if_many",
		prefix = "●",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.INFO] = "I",
			[vim.diagnostic.severity.HINT] = "H",
		},
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local map = { buffer = bufnr, noremap = true, silent = true }

		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", map, { desc = "LSP: hover" }))
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", map, { desc = "LSP: definition" }))
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", map, { desc = "LSP: declaration" }))
		vim.keymap.set(
			"n",
			"gi",
			vim.lsp.buf.implementation,
			vim.tbl_extend("force", map, { desc = "LSP: implementation" })
		)
		-- references: Neovim built-in grr (see :help lsp-defaults)
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", map, { desc = "LSP: rename" }))
		vim.keymap.set(
			{ "n", "v" },
			"<leader>la",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", map, { desc = "LSP: code action" })
		)
		vim.keymap.set("n", "<leader>lf", function()
			require("conform").format({ async = true, lsp_format = "fallback" })
		end, vim.tbl_extend("force", map, { desc = "LSP: format" }))
	end,
})
