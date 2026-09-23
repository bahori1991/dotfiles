-- Even if your gitconfig redirects https to ssh (url insteadOf), this will make sure that
-- plugins will be installed via https instead of ssh.
vim.env.GIT_CONFIG_GLOBAL = ""

-- Remove the white status bar below
vim.o.laststatus = 0
vim.o.cmdheight = 0
vim.o.showmode = false

-- True colour support
vim.o.termguicolors = true

-- lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local function nvim_tree_on_attach(bufnr)
  local api = require("nvim-tree.api")
  local nt_remote = require("nvim_tree_remote")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "l", nt_remote.tabnew_main_pane, opts("Open in treemux without tmux split"))
  vim.keymap.set("n", "<CR>", nt_remote.tabnew_main_pane, opts("Open in treemux without tmux split"))
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close directory"))
  vim.keymap.set("n", "w", api.tree.collapse_all, opts("Collapse All"))

  vim.keymap.set("n", "-", "", { buffer = bufnr })
  vim.keymap.del("n", "-", { buffer = bufnr })
  vim.keymap.set("n", "<C-k>", "", { buffer = bufnr })
  vim.keymap.del("n", "<C-k>", { buffer = bufnr })
  vim.keymap.set("n", "O", "", { buffer = bufnr })
  vim.keymap.del("n", "O", { buffer = bufnr })
end

require("lazy").setup({
  {
    "kiyoon/tmux-send.nvim",
    keys = {
      {
        "-",
        function()
          require("tmux_send").send_to_pane()
          -- (Optional) exit visual mode after sending
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
        end,
        mode = { "n", "x" },
        desc = "Send to tmux pane",
      },
      {
        "_",
        function()
          require("tmux_send").send_to_pane({ add_newline = false })
          -- (Optional) exit visual mode after sending
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
        end,
        mode = { "n", "x" },
        desc = "Send to tmux pane (plain)",
      },
      {
        "<space>-",
        function()
          require("tmux_send").send_to_pane({ count_is_uid = true })
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
        end,
        mode = { "n", "x" },
        desc = "Send to tmux pane w/ pane uid",
      },
      {
        "<space>_",
        function()
          require("tmux_send").send_to_pane({ count_is_uid = true, add_newline = false })
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
        end,
        mode = { "n", "x" },
        desc = "Send to tmux pane w/ pane uid (plain)",
      },
      {
        "<C-_>",
        function()
          require("tmux_send").save_to_tmux_buffer()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
        end,
        mode = { "n", "x" },
        desc = "Save to tmux buffer",
      },
    },
  },
  "kiyoon/nvim-tree-remote.nvim",
  {
    "mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      local c = require("vscode.colors").get_colors()
      return {
        color_overrides = {
          vscBack = "#121212",
          vscTabCurrent = "#121212",
        },
        group_overrides = {
          NormalNC = { bg = c.vscTabOther, fg = c.vscFront },
          LineNr = { bg = c.vscBack, fg = c.vscLineNumber },
          LineNrNC = { bg = c.vscTabOther, fg = c.vscLineNumber },
          SignColumn = { bg = c.vscBack, fg = "NONE" },
          SignColumnNC = { bg = c.vscTabOther, fg = "NONE" },
          CursorLine = { bg = c.vscLeftMid },
          CursorLineNC = { bg = c.vscTabOther },
          CursorLineNr = { bg = c.vscBack, fg = c.vscPopupFront },
          CursorLineNrNC = { bg = c.vscTabOther, fg = c.vscPopupFront },

          NvimTreeNormal = { bg = c.vscBack, fg = c.vscFront },
          NvimTreeNormalNC = { bg = c.vscTabOther, fg = c.vscFront },
          NvimTreeSignColumn = { bg = c.vscBack, fg = "NONE" },
          NvimTreeLineNr = { bg = c.vscBack, fg = c.vscLineNumber },
          NvimTreeCursorLine = { bg = c.vscLeftMid },
          NvimTreeCursorLineNr = { bg = c.vscBack, fg = c.vscPopupFront },
        },
      }
    end,
    config = function(_, opts)
      require("vscode").setup(opts)
      vim.cmd.colorscheme("vscode")
    end,
  },
  "nvim-tree/nvim-web-devicons",
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      local nvim_tree = require("nvim-tree")

      nvim_tree.setup({
        on_attach = nvim_tree_on_attach,
        update_focused_file = {
          enable = true,
          update_cwd = true,
        },
        renderer = {
          --root_folder_modifier = ":t",
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
          width = 30,
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
      })
    end,
  },
  {
    -- without this, nvim-tree often get blocked having "press ENTER to continue"
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Delete all Notifications",
      },
    },
    opts = {
      stages = "fade_in_slide_out",
      -- stages = "slide",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },
  {
    "aserowy/tmux.nvim",
    config = function()
      -- Navigate tmux, and nvim splits.
      -- Sync nvim buffer with tmux buffer.
      require("tmux").setup({
        copy_sync = {
          enable = true,
          sync_clipboard = false,
          sync_registers = true,
        },
        resize = {
          enable_default_keybindings = false,
        },
      })
    end,
  },
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        -- List of default plugins can be found here
        -- https://github.com/neovim/neovim/tree/master/runtime/plugin
        "gzip",
        "matchit", -- Extended %. replaced by vim-matchup
        "matchparen", -- Highlight matching paren. replaced by vim-matchup
        "netrwPlugin", -- File browser. replaced by nvim-tree
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- focus-dim for treemux sidebar
-- local function set_tree_focus(focused)
--   local c = require("vscode.colors").get_colors()
--   local bg = focused and c.vscBack or c.vscTabOther
--   local cl = focused and c.vscLeftMid or c.vscTabOther
--   vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = bg, fg = c.vscFront })
--   vim.api.nvim_set_hl(0, "NvimTreeSignColumn", { bg = bg, fg = "NONE" })
--   vim.api.nvim_set_hl(0, "NvimTreeLineNr", { bg = bg, fg = c.vscLineNumber })
--   vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = cl })
--   vim.api.nvim_set_hl(0, "NvimTreeCursorLineNr", { bg = bg, fg = c.vscPopupFront })
-- end
--
-- vim.api.nvim_create_autocmd("FocusGained", {
--   callback = function()
--     set_tree_focus(true)
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("FocusLost", {
--   callback = function()
--     set_tree_focus(false)
--   end,
-- })
--
-- vim.o.cursorline = true
