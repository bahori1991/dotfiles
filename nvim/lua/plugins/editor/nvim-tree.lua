-- ================================================================================
-- TITLE: nvim-tree/nvim-tree.lua
-- ABOUT: File Explorer for Neovim
-- LINKS: https://github.com/nvim-tree/nvim-tree.lua
-- ================================================================================

return {
  "nvim-tree/nvim-tree.lua",
  event = "VimEnter",
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
            unstaged = "us",
            staged = "s",
            unmerged = "um",
            renamed = "r",
            untracked = "ut",
            deleted = "d",
            ignored = "i",
          }
        }
      }
    },
    filters = {
      dotfiles = false,
      git_ignored = false,
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
  config = function(_, opts)
    require("nvim-tree").setup(opts)
    local tree_opened = false
    local function open_tree()
      if tree_opened then
        return
      end
      if vim.bo.filetype == "dashboard" or vim.bo.filetype == "NvimTree" then
        return 
      end
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "dashboard" then
          return
        end
      end
      if not require("nvim-tree.view").is_visible() then
        require("nvim-tree.api").tree.open()
      end
      tree_opened = true
    end
    
    local function has_startup_files()
      for i = 0, vim.fn.argc() - 1 do
        local arg = vim.fn.argv(i)
        if arg ~= nil and arg ~= "" then
          return true
        end
      end
      return false
    end

    -- When open Neovim with specified file
    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function()
        if has_startup_files() then
          vim.defer_fn(open_tree, 50)
        end
      end,
    })
    -- When open file from dashboard
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function(args)
        if tree_opened then
          return
        end
      local ft = vim.bo[args.buf].filetype
      if ft == "dashboard" or ft == "NvimTree" or ft == "" then
        return
      end
      vim.schedule(open_tree)
    end,
  })
  end,
}
