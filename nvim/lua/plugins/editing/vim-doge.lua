-- ================================================================================
-- TITLE: kkoomen/vim-doge
-- ABOUT: plugin for write JSDoc easily
-- LINKS: https://github.com/kkoomen/vim-doge
-- ================================================================================

return {
	"kkoomen/vim-doge",
	build = ":call doge#install()",
	cmd = { "DogeGenerate" },
	ft = {
		"typescript",
		"typescriptreact",
		"javascript",
		"javascriptreact",
		"tsx",
		"jsx",
		"lua",
		"python",
	},
	config = function()
		vim.g.doge_javascript_settings = {
			destructuring_props = 1,
			omit_redundant_param_types = 1,
		}
		vim.keymap.set("n", "<leader>dg", "<Plug>(doge-generate)", { desc = "Generate doc (vim-doge)" })
		vim.g.doge_mapping_comment_jump_forward = "<C-j>"
		vim.g.doge_mapping_comment_jump_backward = "<C-k>"
	end,
}
