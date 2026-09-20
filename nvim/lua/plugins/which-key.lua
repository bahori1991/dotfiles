-- =====================================================================================================
-- TITLE: folke/which-key.nvim
-- ABOUT: Show custom keymaps for Neovim
-- LINKS: https://github.com/folke/which-key.nvim
-- =====================================================================================================

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    defer = function(ctx)
      return ctx.mode == "v" or ctx.mode == "V" or ctx.mode == "<C-V>"
    end,
    preset = "modern",
    delay = 200,
    notify = true,
    plugins = {
      presets = {
        operators = true,
        motions = false,
        windows = true,
        g = true,
        z = true,
      },
    },
    replace = {
      desc = {
        function(desc)
          return " " .. (desc or "")
        end,
      },
    },
    spec = {
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "Diagnostics" },
      { "<leader>f", group = "Telescope" },
      { "<leader>r", group = "Rename / Refactor" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
