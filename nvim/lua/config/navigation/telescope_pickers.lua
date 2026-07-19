-- ================================================================================
-- TITLE: config.navigation.telescope_pickers
-- ABOUT: Shared Telescope pickers pinned to Neovim's startup cwd (not :cd)
-- ================================================================================

local builtin = require("telescope.builtin")

--- Neovim launch cwd; captured when this module is first required.
local initial_cwd = vim.fn.getcwd()

local M = {}

function M.cwd()
	return initial_cwd
end

function M.find_files()
	builtin.find_files({ cwd = initial_cwd })
end

function M.live_grep()
	builtin.live_grep({ cwd = initial_cwd })
end

return M
