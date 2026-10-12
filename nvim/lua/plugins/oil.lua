-- =====================================================================================================
-- TITLE: stevearc.oil.nvim
-- ABOUT: Edit filesystem like a normal Neovim buffer
-- LINKS: https://github.com/stevearc/oil.nvim
-- =====================================================================================================

local dotnet = require("config.dotnet-workspace")

return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
  },
  opts = {
    default_file_explorer = false,
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, bufnr)
        if not dotnet.has_solution_root(require("oil").get_current_dir(bufnr)) then
          return false
        end
        local base = name:gsub("/+$", "")
        return base == "bin" or base == "obj"
      end,
    },
    use_default_keymaps = false,
    keymaps = {
      ["<CR>"] = "actions.select",
      ["-"] = { "actions.parent", mode = "n" },
      ["<C-r>"] = "actions.refresh",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = { "actions.close", mode = "n" },
      ["g."] = { "actions.toggle_hidden", mode = "n" },
      ["g?"] = { "actions.show_help", mode = "n" },
    },
  },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open File Explorer (Oil)" },
  },
}
