-- ================================================================================
-- TITLE: christoomey/vim-tmux-navigator
-- ABOUT: tmux navigator for Neovim
-- LINKS: https://github.com/christoomey/vim-tmux-navigator
--
-- Fallback (no tmux / no adjacent split): <C-h/l> may appear to do nothing if you
-- rarely use Vim window splits. The plugin has no disable-when-tmux-not-running option.
--
-- Pane resize (tmux side, not Neovim): C-S-h/j/k/l in ~/.tmux.conf
--   ~/.config/dotfiles/tmux/.tmux.conf (and .tmux.term.conf / .tmux.agent.conf)
-- ================================================================================

return {
	"christoomey/vim-tmux-navigator",
	keys = {
		{ "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate: left pane" },
		{ "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate: down pane" },
		{ "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate: up pane" },
		{ "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate: right pane" },
	},
}
