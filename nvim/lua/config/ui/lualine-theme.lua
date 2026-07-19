-- ================================================================================
-- TITLE: lualine-theme.lua
-- ABOUT: Explicit lualine theme (avoids auto/vscode inactive gray)
-- ================================================================================

local colors = require("config.ui.colors")

local M = {}

function M.build()
	local function mode(accent)
		return {
			a = { fg = colors.gray[950], bg = accent, gui = "bold" },
			b = { fg = colors.gray[100], bg = colors.gray[500] },
			c = { fg = colors.gray[100], bg = colors.gray[950] },
		}
	end

	return {
		normal = mode(colors.blue[500]),
		insert = mode(colors.green[500]),
		visual = mode(colors.orange[500]),
		replace = mode(colors.violet[500]),
		terminal = mode(colors.yellow[500]),
		command = mode(colors.cyan[500]),
		-- Same blue family as normal; darker accent + section b distinguish inactive windows
		inactive = {
			a = { fg = colors.gray[950], bg = colors.blue[700] },
			b = { fg = colors.gray[100], bg = colors.gray[700] },
			c = { fg = colors.gray[100], bg = colors.gray[950] },
		},
	}
end

return M
