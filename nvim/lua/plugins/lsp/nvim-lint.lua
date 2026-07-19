-- ========================================================================================
-- TITLE: mfussenegger/nvim-lint
-- ABOUT: Asynchronous linter plugin complementary to LSP
-- LINKS: https://github.com/mfussenegger/nvim-lint
-- ========================================================================================

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			haskell = { "hlint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
