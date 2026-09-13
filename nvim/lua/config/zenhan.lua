-- =====================================================================================================
-- TITLE: zenhan.lua
-- ABOUT: Set IME-off automatically
-- =====================================================================================================

local zenhan = vim.fn.expand("~/.config/dotfiles/scripts/zenhan-off.sh")

local function zenhan_off()
	if vim.fn.executable(zenhan) == 1 then
		vim.fn.jobstart({ zenhan })
	end
end

-- Set IME-off when change mode except for Insert of Replace
vim.api.nvim_create_autocmd("ModeChanged", {
	callback = function()
		local mode = vim.api.nvim_get_mode().mode
		if not mode:match("^[iR]") then
			zenhan_off()
		end
	end,
})
