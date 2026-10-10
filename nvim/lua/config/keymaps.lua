-- =====================================================================================================
-- TITLE: keymaps
-- ABOUT: set keymaps of Neovim
-- =====================================================================================================

-- import dependencies
local env = require("config.lsp-env")

-- disable up/down/left/right
vim.keymap.set({ "n", "i", "v" }, "<Up>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "n", "i", "v" }, "<Down>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "n", "i", "v" }, "<Left>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "n", "i", "v" }, "<Right>", "<Nop>", { noremap = true, silent = true })

-- move current row to center
vim.keymap.set("n", "G", "Gzz", { noremap = true, silent = true })
vim.keymap.set("n", "n", "nzzzv", { noremap = true, silent = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true, silent = true })

-- Redraw Neovim window
vim.keymap.set("n", "<leader>l", "<cmd>nohlsearch<bar>redraw!<cr>", {
  desc = "Redraw / clear search highlight",
})

-- move to end of word after uppercased
vim.keymap.set("n", "gUiw", "gUiwe", { noremap = true })

-- toggle file explorer whether
local function has_solution_in_cwd()
  local cwd = vim.fn.getcwd()
  return vim.fn.glob(cwd .. "/*.slnx") ~= "" or vim.fn.glob(cwd .. "/*.sln") ~= ""
end

local function toggle_nvim_tree()
  require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })
end

local function toggle_solution_explorer()
  vim.cmd("CSharpExplorer")
end

vim.keymap.set("n", "<leader>e", function()
  if env.dotnet_lsp_available() and has_solution_in_cwd() then
    toggle_solution_explorer()
  else
    toggle_nvim_tree()
  end
end, { desc = "Toggle File/Solution Explorer" })
