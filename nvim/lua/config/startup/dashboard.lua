-- ================================================================================
-- TITLE: startup/dashboard.lua
-- ABOUT: Autostart dashboard when Neovim opens with no file arguments
-- ================================================================================

local group = vim.api.nvim_create_augroup("StartupDashboard", { clear = true })

--- dashboard-nvim registers UIEnter in group "dashboard"; keep only our handler
local function clear_plugin_uienter()
	pcall(vim.api.nvim_clear_autocmds, { group = "dashboard", event = "UIEnter" })
end

local function has_dashboard_buffer()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "dashboard" then
			return true
		end
	end
	return false
end

local function prepare_dashboard_buffer()
	-- scratch-cleanup neutralizes the startup buffer on LazyDone before UIEnter.
	if vim.bo.modifiable and vim.api.nvim_buf_get_name(0) == "" then
		return
	end
	vim.cmd.enew()
end

local function open_dashboard()
	if vim.fn.argc() > 0 or vim.bo.filetype == "dashboard" or has_dashboard_buffer() then
		return
	end

	prepare_dashboard_buffer()

	local ok, err = pcall(function()
		require("dashboard"):instance()
	end)
	if not ok then
		vim.notify("dashboard: " .. tostring(err), vim.log.levels.ERROR)
	end
end

clear_plugin_uienter()

vim.api.nvim_create_autocmd("UIEnter", {
	group = group,
	once = true,
	callback = open_dashboard,
})

-- plugin/dashboard.lua is re-sourced on :Lazy reload dashboard-nvim (packadd)
vim.api.nvim_create_autocmd("User", {
	group = group,
	pattern = "LazyLoad",
	callback = function(args)
		if args.data == "dashboard-nvim" then
			clear_plugin_uienter()
		end
	end,
})

-- change_detection / sync may reload plugin runtime paths
vim.api.nvim_create_autocmd("User", {
	group = group,
	pattern = "LazyReload",
	callback = clear_plugin_uienter,
})
