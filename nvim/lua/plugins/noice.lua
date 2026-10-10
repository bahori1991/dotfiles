-- =====================================================================================================
-- TITLE: folke/noice.nvim
-- ABOUT: Replace the UI for messages, cmdline and the popupmenu
-- LINKS: https://github.com/folke/noice.nvim
-- =====================================================================================================

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>nd",
      "<cmd>Noice dismiss<cr>",
      desc = "Dismiss Noice messages",
    },
  },
  opts = {
    cmdline = {
      view = "cmdline_popup",
    },
    views = {
      cmdline_popup = {
        position = { row = "50%", col = "50%" },
        size = {
          min_width = 60,
          width = "auto",
          height = "auto",
        },
      },
      hover = {
        relative = "cursor",
        anchor = "auto",
        position = {
          row = 2,
          col = 0,
        },
        size = {
          max_width = 80,
          max_height = 25,
          height = "auto",
        },
        border = {
          style = "rounded",
        },
        enter = false,
      },
    },
    lsp = {
      progress = {
        enabled = true,
        view = "mini",
        throttle = 1000 / 30,
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
      hover = {
        enabled = true,
      },
    },
    routes = {
      {
        filter = {
          event = "lsp",
          kind = "progress",
        },
        opts = { skip = true },
      },
    },
    notify = {
      enabled = true,
      view = "notify",
    },
    popupmenu = { enabled = false },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    status = {
      lsp_progress = { event = "lsp", kind = "progress" },
    },
  },
}
