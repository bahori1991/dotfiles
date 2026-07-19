-- ================================================================================
-- TITLE: config.completion.blink-cr
-- ABOUT: Post-process blink.cmp <CR> fallback keys for indent after Enter (esp. inside pairs)
-- LINKS: blink.pairs enter keys; indent fix pattern from nvim-autopairs
-- ================================================================================

local M = {}

local cr_term = vim.api.nvim_replace_termcodes("<cr>", true, true, true)
local indent_fix = vim.api.nvim_replace_termcodes("<cmd>normal! ==<cr>", true, true, true)

--- blink.pairs returns literal "<CR><C-o>O"; fallback without mapping returns termcodes
local function opens_line_above(keys)
	return keys:find("<C%-o>O") ~= nil or keys:find("\r\15O", 1, true) ~= nil
end

local function is_plain_cr(keys)
	return keys == cr_term or keys:lower() == "<cr>"
end

function M.fix_indent(keys)
	if not keys then
		return nil
	end
	if opens_line_above(keys) then
		return vim.api.nvim_replace_termcodes(
			"<c-g>u<cr><cmd>normal! ==<cr><up><end><cr>",
			true,
			true,
			true
		)
	end
	if keys:find("<C%-%]>") then
		return keys .. indent_fix
	end
	if is_plain_cr(keys) then
		return keys .. indent_fix
	end
	return keys
end

return M
