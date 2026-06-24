-- ================================================================================
-- TITLE: nvim-tree/nvim-tree.lua
-- ABOUT: File Explorer for Neovim
-- LINKS: https://github.com/nvim-tree/nvim-tree.lua
-- ================================================================================

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      actions = {
        open_file = {
          window_picker = {
            enable = true,
            picker = "default",
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
      },
    })
  end,
  keys = {
    { "<leader>e", "<cmd>NvimTreeOpen<cr>", desc = "NvimTreeOpen" }
  },
}

