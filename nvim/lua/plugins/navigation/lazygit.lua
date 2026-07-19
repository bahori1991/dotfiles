-- ================================================================================
-- TITLE: kdheepak/lazygit.nvim
-- ABOUT: Plugin for calling lazygit from within Neovim
-- LINKS: https://github.com/kdheepak/lazygit.nvim
-- ================================================================================

return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "Git: lazygit (repo root)" },
		{ "<leader>gG", "<cmd>LazyGitCurrentFile<cr>", desc = "Git: lazygit (current file)" },
	},
}
