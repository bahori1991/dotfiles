-- ================================================================================
-- TITLE: stevearc/oil.nvim
-- ABOUT: Edit filesystem like a normal Neovim buffer
-- LINKS: https://github.com/stevearc/oil.nvim
-- ================================================================================

return {
  "stevearc/oil.nvim",
  ---@module "oil"
  ---@type oil.SetupOpts
  opts = {},
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
  },
  lazy = false,
  config = function(_, opts)
    require("oil").setup(opts)
    vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        vim.wo.winbar = ""
      end,
    })
  end,
}
