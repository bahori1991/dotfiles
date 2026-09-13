-- =====================================================================================================
-- TITLE: treemux-sync.lua
-- ABOUT: sync selected file between Neovim and treemux
-- =====================================================================================================

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
	callback = function()
		if vim.bo.buftype ~= "" then
			return
		end
		local file = vim.fn.expand("%:p")
		if file == "" or not vim.fn.filereadable(file) then
			return
		end
		local pane = vim.env.TMUX_PANE
		if not pane then
			return
		end
		local sidebar = vim.fn
			.system(string.format("tmux show-option -gv '@-treemux-registered-pane-%s' 2>/dev/null", pane))
			:gsub("%s+$", "")
		if sidebar == "" then
			return
		end
		sidebar = sidebar:match("^([^,]+)")
		if not sidebar then
			return
		end
		local lua_cmd = string.format('require("nvim-tree.api").tree.find_file({ buf = %q, open = false })', file)
		vim.fn.system(
			string.format("tmux send-keys -t %s -- %s Enter", sidebar, vim.fn.shellescape(":lua " .. lua_cmd))
		)
	end,
})
