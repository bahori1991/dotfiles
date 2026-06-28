-- ================================================================================
-- TITLE: nvim-telescope/telescope.nvim
-- ABOUT: highly extendable fuzzy finder over lists
-- LINKS: https://github.com/nvim-telescope/telescope.nvim
-- ================================================================================

local colors = require("config/colors")

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  opts = {},
  config = function(_, opts)
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
    vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Telescope commands" })
    vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope diagnostics" })
    vim.keymap.set("n", "<leader>fdc", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Telescope current buffer" })
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = colors.blue , bg = colors.bg })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = colors.blue , bg = colors.bg })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = colors.blue , bg = colors.bg })
    require("telescope").setup(opts)
  end,
}
