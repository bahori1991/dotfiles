-- ================================================================================
-- TITLE: messages.lua
-- ABOUT: Show Neovim message history in a floating window
-- ================================================================================

local M = {}

local float_win = nil

local function close_float()
	if float_win and vim.api.nvim_win_is_valid(float_win) then
		vim.api.nvim_win_close(float_win, true)
	end
	float_win = nil
end

local function collect_lines()
	local lines = vim.split(vim.fn.execute("messages"), "\n", { plain = true })
	if lines[1] == "" then
		table.remove(lines, 1)
	end
	if lines[#lines] == "" then
		lines[#lines] = nil
	end
	if #lines == 0 then
		return { "(no messages)" }
	end
	return lines
end

function M.show()
	close_float()

	local lines = collect_lines()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].swapfile = false
	vim.bo[buf].filetype = "messages"

	local max_width = 0
	for _, line in ipairs(lines) do
		max_width = math.max(max_width, vim.api.nvim_strwidth(line))
	end

	local width = math.min(math.max(max_width + 2, 32), vim.o.columns - 4)
	local height = math.min(math.max(#lines, 1), math.floor(vim.o.lines * 0.8))
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	float_win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	vim.wo[float_win].wrap = true
	vim.wo[float_win].number = false
	vim.wo[float_win].relativenumber = false
	vim.wo[float_win].cursorline = false

	local close_opts = { buffer = buf, silent = true, nowait = true }
	vim.keymap.set("n", "q", close_float, vim.tbl_extend("force", close_opts, { desc = "Close messages" }))
	vim.keymap.set("n", "<Esc>", close_float, close_opts)
end

return M
