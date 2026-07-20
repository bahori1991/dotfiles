-- ================================================================================
-- TITLE: scratch-cleanup
-- ABOUT: Suppress W13 on tmux focus changes by cleaning empty scratch buffers
-- ================================================================================

local M = {}

local SCRATCH_NAME = "[nvim-dev-scratch]"

local TELESCOPE_FT = {
	TelescopePrompt = true,
	TelescopeResults = true,
	TelescopePreview = true,
}

--- Run :checktime only when not in cmdline/replace/terminal mode.
function M.run_safe_checktime()
	local mode = vim.api.nvim_get_mode().mode
	if mode:match("^[cr!t]") then
		return
	end
	if vim.fn.getcmdwintype() ~= "" then
		return
	end
	pcall(vim.cmd, "checktime")
end

--- Register focus/resume hooks (registered before lazy.nvim so wipe runs first).
--- Does not delete foreign :checktime autocmds; Neovim 0.12+ autoread uses file watchers.
function M.setup_focus_checktime(group)
	local events = { "FocusGained", "VimResume" }
	vim.api.nvim_clear_autocmds({ group = group, event = events })

	vim.api.nvim_create_autocmd(events, {
		group = group,
		callback = function()
			M.wipe_scratch_buffers()
			M.run_safe_checktime()
		end,
	})
end

function M.delete_buffer(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	-- Drop stale diagnostic cache entries before wipe (avoids Invalid buffer id on config refresh)
	pcall(vim.diagnostic.reset, nil, buf)

	vim.bo[buf].modified = false
	vim.bo[buf].buflisted = false
	vim.bo[buf].bufhidden = "wipe"

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if not vim.api.nvim_win_is_valid(win) then
			goto continue
		end
		if vim.api.nvim_win_get_buf(win) == buf then
			local alt = vim.fn.bufnr("#")
			if alt > 0 and alt ~= buf and vim.api.nvim_buf_is_valid(alt) then
				pcall(vim.api.nvim_win_set_buf, win, alt)
			end
		end
		::continue::
	end

	pcall(vim.api.nvim_buf_delete, buf, { force = true })
	if vim.api.nvim_buf_is_valid(buf) then
		pcall(vim.cmd, "silent! bwipeout! " .. buf)
	end
end

--- W13 targets File ""; nofile buffers often reject nvim_buf_set_name.
function M.neutralize_scratch_buffer(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	if vim.bo[buf].filetype == "dashboard" then
		return
	end
	if vim.bo[buf].buftype == "terminal" then
		return
	end

	pcall(vim.api.nvim_buf_call, buf, function()
		vim.bo.modified = false
		local saved_buftype = vim.bo.buftype
		if saved_buftype == "nofile" then
			vim.bo.buftype = ""
		end
		if vim.api.nvim_buf_get_name(0) == "" then
			vim.cmd("silent! file " .. vim.fn.fnameescape(SCRATCH_NAME))
		end
		if saved_buftype == "nofile" then
			vim.bo.buftype = "nofile"
		end
		vim.bo.modifiable = false
		vim.bo.buflisted = false
		vim.bo.bufhidden = "hide"
		vim.bo.swapfile = false
	end)
end

function M.is_scratch_buffer(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return false
	end
	local name = vim.api.nvim_buf_get_name(buf)
	if name ~= "" and name ~= SCRATCH_NAME then
		return false
	end
	if vim.bo[buf].filetype == "dashboard" then
		return false
	end
	if TELESCOPE_FT[vim.bo[buf].filetype] then
		return false
	end
	if vim.bo[buf].buftype == "terminal" then
		return false
	end
	return true
end

function M.clean_scratch_buffer(buf)
	if not M.is_scratch_buffer(buf) then
		return
	end
	M.delete_buffer(buf)
	if vim.api.nvim_buf_is_valid(buf) and M.is_scratch_buffer(buf) then
		M.neutralize_scratch_buffer(buf)
	end
end

function M.wipe_scratch_buffers()
	local dashboard_buf
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "dashboard" then
			dashboard_buf = buf
			break
		end
	end

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if dashboard_buf and buf == dashboard_buf then
			goto continue
		end
		M.clean_scratch_buffer(buf)
		::continue::
	end
end

function M.normalize_dashboard_buffer()
	if vim.bo.filetype ~= "dashboard" then
		return
	end
	vim.bo.modified = false
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false
	local name = vim.api.nvim_buf_get_name(0)
	if name ~= "" and vim.fn.isdirectory(name) == 1 then
		pcall(vim.api.nvim_buf_set_name, 0, "")
	end
end

function M.setup_autocmds()
	if vim.env.NVIM_IN_TMUX ~= "1" then
		return
	end

	local group = vim.api.nvim_create_augroup("ScratchCleanup", { clear = true })

	M.setup_focus_checktime(group)

	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "dashboard",
		callback = function()
			M.normalize_dashboard_buffer()
			M.wipe_scratch_buffers()
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "LazyDone",
		callback = function()
			-- Keep the startup buffer modifiable until dashboard opens on UIEnter.
			if vim.fn.argc() == 0 then
				return
			end
			M.wipe_scratch_buffers()
		end,
	})

	vim.api.nvim_create_autocmd({ "FocusLost", "VimSuspend" }, {
		group = group,
		callback = M.wipe_scratch_buffers,
	})

	vim.api.nvim_create_autocmd("FileChangedShell", {
		group = group,
		callback = function(args)
			M.clean_scratch_buffer(args.buf)
		end,
	})
end

if vim.env.NVIM_IN_TMUX == "1" then
	M.setup_autocmds()
end

return M
