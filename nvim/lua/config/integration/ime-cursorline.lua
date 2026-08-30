-- ================================================================================
-- TITLE: ime-cursorline.lua
-- ABOUT: Light blue cursor line when IME is on in insert mode (WSL + zenhan).
-- ================================================================================

local M = {}

if vim.fn.has("wsl") ~= 1 then
	return M
end

local colors = require("config.ui.colors")
local zenhan = require("config.integration.zenhan")

local ZENHAN = "/mnt/c/users/bahori1991/bin/zenhan/zenhan.exe"
local QUERY_DEBOUNCE_MS = 50
local POLL_MS = 500

local HL_DEFAULT = {
	CursorLine = { bg = colors.gray[800] },
	CursorLineNr = { bg = colors.gray[800], fg = colors.yellow[500], bold = true },
}
local HL_IME = {
	CursorLine = { bg = colors.blue[700] },
	CursorLineNr = { bg = colors.blue[700], fg = colors.blue[200], bold = true },
}

M._displayed = nil
M._known_ime = nil

local query_debounce = vim.uv.new_timer()
local poll_timer = vim.uv.new_timer()
local query_in_flight = false
local query_job = nil
local group = nil

local function is_insert_mode()
	local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
	return mode == "i" or mode == "R" or mode == "r"
end

local function should_sync()
	if not zenhan._focused or not is_insert_mode() then
		return false
	end
	local ft = vim.bo.filetype
	if ft == "NvimTree" or ft == "dashboard" or ft:match("^Telescope") then
		return false
	end
	return true
end

function M.set_ime(ime_on)
	if M._displayed == ime_on then
		return
	end
	M._displayed = ime_on
	local spec = ime_on and HL_IME or HL_DEFAULT
	for hl_group, hl_spec in pairs(spec) do
		vim.api.nvim_set_hl(0, hl_group, hl_spec)
	end
end

local function reset_highlight()
	M._known_ime = nil
	M._displayed = nil
	for hl_group, hl_spec in pairs(HL_DEFAULT) do
		vim.api.nvim_set_hl(0, hl_group, hl_spec)
	end
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

local function apply_queried_ime(ime_on)
	M._known_ime = ime_on
	M.set_ime(ime_on)
end

local function do_query()
	if not should_sync() then
		return
	end
	if vim.fn.filereadable(ZENHAN) ~= 1 then
		return
	end
	if query_in_flight then
		return
	end

	query_in_flight = true
	query_job = vim.system({ ZENHAN }, { text = true }, function(obj)
		query_in_flight = false
		query_job = nil
		vim.schedule(function()
			if not should_sync() then
				return
			end
			local ime_on = parse_ime_result(obj)
			if ime_on == M._known_ime then
				return
			end
			apply_queried_ime(ime_on)
		end)
	end)
end

local function request_query()
	query_debounce:stop()
	query_debounce:start(QUERY_DEBOUNCE_MS, 0, vim.schedule_wrap(do_query))
end

local function update_poll_timer()
	if should_sync() then
		poll_timer:stop()
		poll_timer:start(POLL_MS, POLL_MS, vim.schedule_wrap(do_query))
	else
		poll_timer:stop()
	end
end

local function stop_poll()
	query_debounce:stop()
	poll_timer:stop()
	if query_job then
		query_job:kill("sigterm")
		query_job = nil
		query_in_flight = false
	end
end

local function on_insert_left()
	stop_poll()
	reset_highlight()
end

function M.setup()
	if M._did_setup then
		return
	end
	M._did_setup = true

	group = vim.api.nvim_create_augroup("UserImeCursorline", { clear = true })

	vim.api.nvim_create_autocmd("InsertEnter", {
		group = group,
		callback = function()
			request_query()
			update_poll_timer()
		end,
	})

	vim.api.nvim_create_autocmd("InsertLeave", {
		group = group,
		callback = on_insert_left,
	})

	vim.api.nvim_create_autocmd("ModeChanged", {
		group = group,
		callback = function()
			if is_insert_mode() then
				request_query()
				update_poll_timer()
			else
				on_insert_left()
			end
		end,
	})

	vim.api.nvim_create_autocmd("FocusLost", {
		group = group,
		callback = function()
			stop_poll()
		end,
	})

	vim.api.nvim_create_autocmd("FocusGained", {
		group = group,
		callback = function()
			if is_insert_mode() then
				request_query()
				update_poll_timer()
			end
		end,
	})

	vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
		group = group,
		callback = function()
			stop_poll()
			M._known_ime = nil
			M._displayed = nil
		end,
	})

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = function()
			if not should_sync() then
				return
			end
			local displayed = M._displayed
			M._displayed = nil
			if displayed ~= nil then
				M.set_ime(displayed)
			end
		end,
	})
end

M.setup()

return M
