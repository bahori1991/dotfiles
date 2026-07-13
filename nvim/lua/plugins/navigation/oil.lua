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
  keys = {
    { "-", function() require("oil").open() end, desc = "Open parent directory" },
  },
  config = function(_, opts)
    require("oil").setup(opts)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        vim.wo.winbar = ""
      end,
    })
  end,
}
