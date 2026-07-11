-- ================================================================================
-- TITLE: stevearc/oil.nvim
-- ABOUT: Edit filesystem like a normal Neovim buffer
-- LINKS: https://github.com/stevearc/oil.nvim
-- ================================================================================

return {
  "stevearc/oil.nvim",
  ---@module "oil"
  ---@type oil.SetupOpts
  cmd = { "Oil" },
  opts = {
    default_file_explorer = false,
    view_options = {
      show_hidden = true,
    },
  },
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
  },
  config = function(_, opts)
    require("oil").setup(opts)
    vim.keymap.set("n", "<leader>-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        vim.wo.winbar = ""
      end,
    })
  end,
}
