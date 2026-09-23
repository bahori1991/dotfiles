-- =====================================================================================================
-- TITLE: nvim-tree/nvim-tree
-- ABOUT: File Explorer of Neovim
-- LINKS: https://github.com/nvim-tree/nvim-tree.lua
-- =====================================================================================================

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>e",
      function()
        require("nvim-tree.api").tree.toggle({ focus = true, find_file = true })
      end,
      desc = "Toggle File Tree (nvim-tree)",
    },
  },
  opts = {
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    renderer = {
      icons = {
        git_placement = "right_align",
        glyphs = {
          default = "",
          symlink = "",
          folder = {
            arrow_open = "",
            arrow_closed = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          },
          git = {
            unstaged = "",
            staged = "S",
            unmerged = "",
            renamed = "➜",
            untracked = "U",
            deleted = "",
            ignored = "◌",
          },
        },
      },
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      },
    },
    view = {
      width = 40,
      side = "left",
    },
    filters = {
      dotfiles = false,
      git_ignored = true,
      custom = {
        "^\\.git$",
        "^\\.git/",
        "^\\.cursor$",
        "^\\.cursor/",
      },
    },
    disable_netrw = true,
    hijack_netrw = true,
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")
      api.map.on_attach.default(bufnr)
      local function opts(desc)
        return {
          desc = "nvim-tree: " .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        }
      end
      vim.keymap.set("n", "w", function()
        api.tree.collapse_all()
      end, opts("Close all file trees"))
    end,
  },
}
