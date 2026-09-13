-- =====================================================================================================
-- TITLE: christoomey/vim-tmux-navigator
-- ABOUT: Navigate seamlessly between Neovim and tmux spilts
-- LINKS: https://github.com/christoomey/vim-tmux-navigator
-- =====================================================================================================

return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  init = function()
    vim.g.tmux_navigator_no_mappings = 1
    vim.g.tmux_navigator_disable_when_zoomed = 1
  end,
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate pane to Left" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate pane to Down" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate pane to Up" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate pane to Right" },
  },
}

