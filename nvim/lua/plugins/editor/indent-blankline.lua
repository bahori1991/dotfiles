-- ================================================================================
-- TITLE: lukas-reineke/indent-blankline
-- ABOUT: indentation guides to Neovim
-- LINKS: https://github.com/lukas-reineke/indent-blankline.nvim
-- ================================================================================

local colors = require("config.colors")

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl",
  ---@type ibl.config
  opts = {
    indent = {
      char = "┊",
      highlight = "Default"
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
      show_exact_scope = true,
      highlight = "Blue",
      include = {
        node_type = {
          lua = {
            "table_constructor"
          },
          javascript = {
            "object",
            "array"
          },
          typescript = {
            "object",
            "array"
          },
          tsx = {
            "object",
            "array"
          }
        }
      }
    },
    exclude = {
      filetypes = {
        "dashboard", "help", "lazy", "mason"
      }
    }
  },
  config = function(_, opts)
    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "Blue", { fg = colors.blue })
      vim.api.nvim_set_hl(0, "Default", { fg = colors.gray })
    end)
    require("ibl").setup(opts)
  end,
}
