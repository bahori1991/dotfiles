-- ================================================================================
-- TITLE: nvim-tree/nvim-tree.lua
-- ABOUT: File Explorer for Neovim
-- LINKS: https://github.com/nvim-tree/nvim-tree.lua
-- ================================================================================

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  ---@module "nvim_tree"
  ---@type nvim_tree.config
  opts = {
    sort = {
      sorter = "case_sensitive",
    },
    view = {
      width = 40,
    },
    renderer = {
      group_empty = true,
      icons = {
        git_placement = "right_align",
        glyphs = {
          git = {
            unstaged = "s",
            staged = "S",
            unmerged = "m",
            renamed = "R",
            untracked = "t",
            deleted = "D",
            ignored = "i",
          }
        }
      }
    },
    filters = {
      dotfiles = true,
    },
    git = {
      ignore = true,
      show_on_dirs = true,
      show_on_open_dirs = true,
      timeout = 1000,
    },
  },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle Nvim-tree" }
  },
}

