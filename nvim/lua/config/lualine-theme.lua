-- ================================================================================
-- TITLE: lualine-theme.lua
-- ABOUT: Explicit lualine theme (avoids auto/vscode inactive gray)
-- ================================================================================

local colors = require("config.colors")

local M = {}

function M.build()
	local function mode(accent)
		return {
			a = { fg = colors.bg, bg = accent, gui = "bold" },
			b = { fg = colors.fg, bg = colors.gray },
			c = { fg = colors.fg, bg = colors.bg },
		}
	end

	return {
		normal = mode(colors.blue),
		insert = mode(colors.green),
		visual = mode(colors.orange),
		replace = mode(colors.violet),
		terminal = mode(colors.yellow),
		command = mode(colors.cyan),
		inactive = mode(colors.blue),
	}
end

return M
