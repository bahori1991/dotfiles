-- =====================================================================================================
-- TITLE: rest-nvim/rest.nvim
-- ABOUT: HTTP client in Neovim
-- LINKS: https://github.com/rest-nvim/rest.nvim
-- =====================================================================================================

return {
  "rest-nvim/rest.nvim",
  ft = { "http" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    vim.g.rest_nvim = {
      _log_level = "DEBUG",
      env = {
        enable = true,
        pattern = ".*%.env.*",
      },
      response = {
        hooks = {
          format = true,
        },
      },
    }
    vim.keymap.set("n", "<leader>rr", "<cmd>belowright horizontal Rest run<cr>", {
      buffer = true,
      desc = "Run HTTP Request (rest.nvim)",
    })
  end,
}
