-- ================================================================================
-- TITLE: startup/dashboard.lua
-- ABOUT: Autostart dashboard when Neovim opens with no file arguments
-- ================================================================================

vim.api.nvim_create_autocmd("UIEnter", {
	once = true,
	callback = function()
		if vim.fn.argc() > 0 or vim.bo.filetype == "dashboard" then
			return
		end

		-- dashboard-nvim built-in UIEnter also calls instance(); disable to avoid double show
		pcall(vim.api.nvim_clear_autocmds, { group = "dashboard", event = "UIEnter" })

		require("dashboard"):instance()
	end,
})
