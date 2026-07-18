-- ================================================================================
-- TITLE: christoomey/vim-tmux-navigator
-- ABOUT: tmux navigator for Neovim
-- LINKS: https://github.com/christoomey/vim-tmux-navigator
-- ================================================================================

return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Move to left pane (vim-tmux-navigator)" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Move to below pane (vim-tmux-navigator)" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Move to above pane (vim-tmux-navigator)" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Move to right pane (vim-tmux-navigator)" },
  },
}
