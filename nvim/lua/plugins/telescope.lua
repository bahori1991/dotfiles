-- =====================================================================================================
-- TITLE: nvim-telescope/telescope.nvim
-- ABOUT: Fuzzy finder for files, grep, buffers, LSP, etc.
-- LINKS: https://github.com/nvim-telescope/telescope.nvim
-- =====================================================================================================

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (Telescope)" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep (Telescope)" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers (Telescope)" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags (Telescope)" },
    { "<leader>fn", "<cmd>Telescope notify<cr>", desc = "Notification History (Telescope)" },
    {
      "<leader>fd",
      function()
        require("telescope.builtin").diagnostics()
      end,
      desc = "Diagnostics (Telescope)",
    },
    {
      "<leader>fs",
      function()
        require("telescope.builtin").lsp_document_symbols()
      end,
      desc = "LSP Document Symbols (Telescope)",
    },
    {
      "<leader>fr",
      function()
        require("telescope.builtin").lsp_references()
      end,
      desc = "LSP References (Telescope)",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    telescope.setup({
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            width = 0.95,
            height = 0.90,
            prompt_position = "bottom",
            preview_cutoff = 0,
            preview_width = 0.5,
          },
        },
        path_display = { "truncate", "smart" },
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = false,
        },
        live_grep = {
          additional_args = function(_)
            return { "--hidden" }
          end,
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
        },
      },
    })
    pcall(telescope.load_extension, "fzf")
  end,
}
