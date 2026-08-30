-- ================================================================================
-- TITLE: zenhan.lua
-- ABOUT: Switch the mode of input method editor from terminal.
-- LINKS: https://neovim.io/doc/user/options/
-- ================================================================================

local M = {}

local zenhan_script = vim.fn.expand("~/.config/dotfiles/scripts/zenhan-off.sh")
local ZENHAN = "/mnt/c/users/bahori1991/bin/zenhan/zenhan.exe"
local POLL_MS = 100

M._focused = true

local poll_timer = vim.uv.new_timer()
local query_in_flight = false
local query_job = nil

--- @return boolean|nil true when IME may stay on; false when it must be off; nil to skip (cmdline/terminal)
function M.ime_input_allowed()
	local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
	if mode == "c" or mode == "t" then
		return nil
	end
	return mode == "i" or mode == "R" or mode == "r"
end

function M.should_enforce_off()
	if not M._focused then
		return false
	end
	return M.ime_input_allowed() == false
end

function M.off()
	if vim.fn.executable("bash") == 1 and vim.fn.filereadable(zenhan_script) == 1 then
		vim.fn.system({ "bash", zenhan_script })
	else
		vim.notify("cannot find zenhan script", vim.log.levels.WARN)
	end
end

local function enforce_off_if_needed()
	if M.should_enforce_off() then
		M.off()
	end
end

local function should_poll()
	if not M._focused then
		return false
	end
	local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
	return mode ~= "c" and mode ~= "t"
end

local function parse_ime_result(obj)
	local out = vim.trim(obj.stdout or "")
	if out == "1" then
		return true
	end
	if out == "0" then
		return false
	end
	return obj.code == 1
end

local function poll_ime()
	if not should_poll() or vim.fn.filereadable(ZENHAN) ~= 1 or query_in_flight then
		return
	end

	query_in_flight = true
	query_job = vim.system({ ZENHAN }, { text = true }, function(obj)
		query_in_flight = false
		query_job = nil
		vim.schedule(function()
			if not should_poll() then
				return
			end
			if M.should_enforce_off() and parse_ime_result(obj) then
				M.off()
			end
		end)
	end)
end

local function update_poll_timer()
	if should_poll() then
		poll_timer:stop()
		poll_timer:start(POLL_MS, POLL_MS, vim.schedule_wrap(poll_ime))
	else
		poll_timer:stop()
	end
end

local function stop_poll()
	poll_timer:stop()
	if query_job then
		query_job:kill("sigterm")
		query_job = nil
		query_in_flight = false
	end
end

function M.setup()
	if M._did_setup or vim.fn.has("wsl") ~= 1 then
		return
	end
	M._did_setup = true

	local group = vim.api.nvim_create_augroup("UserZenhan", { clear = true })

	vim.api.nvim_create_autocmd("InsertLeave", {
		group = group,
		pattern = "*",
		callback = M.off,
	})

	vim.api.nvim_create_autocmd("ModeChanged", {
		group = group,
		callback = function()
			enforce_off_if_needed()
			update_poll_timer()
		end,
	})

	vim.api.nvim_create_autocmd("CmdlineLeave", {
		group = group,
		callback = M.off,
	})

	vim.api.nvim_create_autocmd("FocusGained", {
		group = group,
		callback = function()
			M._focused = true
			enforce_off_if_needed()
			update_poll_timer()
		end,
	})

	vim.api.nvim_create_autocmd("FocusLost", {
		group = group,
		callback = function()
			M._focused = false
			stop_poll()
		end,
	})

	vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
		group = group,
		callback = stop_poll,
	})

	vim.keymap.set("n", "<Esc>", M.off, { desc = "IME: off" })

	update_poll_timer()
end

M.setup()

return M
