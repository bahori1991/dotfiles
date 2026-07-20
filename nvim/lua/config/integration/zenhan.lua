-- ================================================================================
-- TITLE: zenhan.lua
-- ABOUT: Switch the mode of input method editor from terminal.
-- LINKS: https://neovim.io/doc/user/options/
-- ================================================================================

local zenhan_script = vim.fn.expand("~/.config/dotfiles/scripts/zenhan-off.sh")

local ime_off = function()
	if vim.fn.executable("bash") == 1 and vim.fn.filereadable(zenhan_script) == 1 then
		vim.fn.system({ "bash", zenhan_script })
	else
		vim.notify("cannot find zenhan script", vim.log.levels.WARN)
	end
end

if vim.fn.has("wsl") == 1 then
	-- vim.api.nvim_create_autocmd("InsertLeave", {
	--   pattern = "*",
	--   callback = ime_off
	-- })
	vim.keymap.set("n", "<Esc>", ime_off, { desc = "IME: off" })
end
