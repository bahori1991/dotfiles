-- ================================================================================
-- TITLE: kkoomen/vim-doge
-- ABOUT: plugin for write JSDoc easily
-- LINKS: https://github.com/kkoomen/vim-doge
-- ================================================================================

return {
	"kkoomen/vim-doge",
	build = function()
		coroutine.yield("vim-doge: installing binary...")
		if vim.fn.exists("*doge#install") ~= 1 then
			vim.notify("vim-doge: doge#install() not available", vim.log.levels.ERROR)
			return
		end
		local ok, err = pcall(vim.fn["doge#install"])
		if not ok then
			vim.notify(
				"vim-doge: install failed (network/curl may be required): " .. tostring(err),
				vim.log.levels.ERROR
			)
		end
	end,
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
		vim.keymap.set("n", "<leader>Dg", "<Plug>(doge-generate)", { desc = "Doc: generate" })
		-- tmux-navigator uses <C-j>/<C-k> for pane navigation (Normal mode)
		vim.g.doge_mapping_comment_jump_forward = "]]"
		vim.g.doge_mapping_comment_jump_backward = "[["
	end,
}
