-- ================================================================================
-- TITLE: tmux-agent-toggle.lua
-- ABOUT: Toggle nvim-dev agent pane with Ctrl+A from Neovim (fallback).
-- NOTE: tmux binds C-a at root in nvim-dev; this covers edge cases in Neovim.
-- ================================================================================

local toggle_script = vim.fn.expand("~/.config/dotfiles/scripts/tmux-toggle-agent-pane.sh")

local function toggle_agent_pane()
	if vim.fn.executable("bash") ~= 1 or vim.fn.filereadable(toggle_script) ~= 1 then
		return
	end
	vim.fn.system({ "bash", toggle_script })
end

if vim.env.NVIM_IN_TMUX == "1" then
	vim.keymap.set({ "n", "i", "v" }, "<C-a>", toggle_agent_pane, { desc = "Toggle agent tmux pane", silent = true })
end
