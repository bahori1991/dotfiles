-- ================================================================================
-- TITLE: treesitter-safe.lua
-- ABOUT: Guard vim.treesitter.get_node_text against stale node ranges (Neovim 0.12+)
-- ================================================================================

local M = {}

local LOG_PATH = "/home/bahori1991/.config/dotfiles/.cursor/debug-2e3697.log"

local function debug_log(payload)
	-- #region agent log
	local f = io.open(LOG_PATH, "a")
	if not f then
		return
	end
	payload.sessionId = "2e3697"
	payload.timestamp = vim.uv.now()
	f:write(vim.json.encode(payload) .. "\n")
	f:close()
	-- #endregion
end

function M.setup()
	local orig = vim.treesitter.get_node_text

	---@diagnostic disable-next-line: duplicate-set-field
	vim.treesitter.get_node_text = function(node, source, opts)
		local ok, result = pcall(orig, node, source, opts)
		if ok then
			return result
		end

		local buf = type(source) == "number" and source or vim.api.nvim_get_current_buf()
		local srow, scol, erow, ecol = node:range()
		debug_log({
			runId = "post-fix",
			hypothesisId = "A",
			location = "treesitter-safe.lua:get_node_text",
			message = "stale node handled (returned empty string)",
			data = {
				error = tostring(result),
				buf = buf,
				filetype = vim.bo[buf].filetype,
				bufname = vim.api.nvim_buf_get_name(buf),
				line_count = vim.api.nvim_buf_line_count(buf),
				node_range = { srow, scol, erow, ecol },
			},
		})

		return ""
	end
end

return M
