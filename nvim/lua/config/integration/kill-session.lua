-- ================================================================================
-- TITLE: kill-session
-- ABOUT: kill tmux session only when :qa / :qall is executed
-- ================================================================================

local M = { should_kill = false }

local QA_CMDS = {
	qa = true,
	["qa!"] = true,
	qall = true,
	["qall!"] = true,
	quitall = true,
	["quitall!"] = true,
}

local function is_qa_cmd(cmd)
	cmd = vim.fn.tolower(vim.trim(cmd))
	return QA_CMDS[cmd] == true
end

local function can_kill_tmux_session()
	if vim.env.NVIM_IN_TMUX ~= "1" then
		return false
	end
	if #vim.api.nvim_list_uis() == 0 then
		return false
	end
	if not vim.env.TMUX or vim.env.TMUX == "" then
		return false
	end
	return true
end

local function get_tmux_session_name()
	local result = vim.fn.system({ "tmux", "display-message", "-p", "#S" })
	if vim.v.shell_error ~= 0 then
		return nil
	end
	local name = vim.trim(result)
	if name == "" then
		return nil
	end
	return name
end

local group = vim.api.nvim_create_augroup("KillSession", { clear = true })

vim.api.nvim_create_autocmd("QuitPre", {
	group = group,
	callback = function()
		M.should_kill = is_qa_cmd(vim.fn.histget(":", -1))
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	pattern = "*",
	group = group,
	callback = function()
		if not M.should_kill or not can_kill_tmux_session() then
			return
		end
		local session = get_tmux_session_name()
		if session then
			vim.fn.system({ "tmux", "kill-session", "-t", session })
		end
	end,
})
