-- ================================================================================
-- TITLE: comment-auto-insert.lua
-- ABOUT: Toggle formatoptions r/o (auto-insert comment leader on Enter and o/O).
-- ================================================================================

local M = {}

M.enabled = false

local function apply_to_buf(bufnr)
	vim.api.nvim_buf_call(bufnr, function()
		if M.enabled then
			vim.opt_local.formatoptions:append("r")
			vim.opt_local.formatoptions:append("o")
		else
			vim.opt_local.formatoptions:remove({ "r", "o" })
		end
	end)
end

function M.apply(bufnr)
	apply_to_buf(bufnr or 0)
end

function M.toggle()
	M.enabled = not M.enabled
	M.apply(0)
	vim.api.nvim_echo({ { "Comment auto-insert: " .. (M.enabled and "on" or "off"), "ModeMsg" } }, true, {})
end

function M.setup()
	local group = vim.api.nvim_create_augroup("UserCommentAutoInsert", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
		group = group,
		callback = function(args)
			apply_to_buf(args.buf)
		end,
	})
end

return M
