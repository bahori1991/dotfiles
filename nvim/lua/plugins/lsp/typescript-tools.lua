-- ========================================================================================
-- TITLE: pmizio/typescript-tools.nvim
-- ABOUT: Typescript integration Neovim deserves
-- LINKS: https://github.com/pmizio/typescript-tools.nvim
-- ========================================================================================

return {
	"pmizio/typescript-tools.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"neovim/nvim-lspconfig",
		"saghen/blink.cmp",
	},
	ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	opts = function()
		return {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
			settings = {
				separate_diagnostic_server = false,
				expose_as_code_action = {
					"fix_all",
					"organize_imports",
					"remove_unused",
					"remove_unused_imports",
					"add_missing_imports",
				},
				tsserver_file_preferences = {
					includeInlayParameterNameHints = "all",
					includeCompletionsForModuleExports = true,
				},
				tsserver_format_options = {},
			},
		}
	end,
}
