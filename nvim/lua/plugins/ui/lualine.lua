-- ================================================================================
-- TITLE: nvim-lualine/lualine.nvim
-- ABOUT: configure Neovim statusline written in lua
-- LINKS: https://github.com/nvim-lualine/lualine.nvim
-- ================================================================================

local lualine_theme = require("config.ui.lualine-theme")

local function lsp_clients()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if next(clients) == nil then
		return "no LSP"
	end
	local client_names = {}
	for _, client in pairs(clients) do
		table.insert(client_names, client.name)
	end
	return "LSP: " .. table.concat(client_names, ", ")
end

-- Minute-granularity cache: avoids os.date on every statusline refresh.
local cached_time = ""

local function schedule_time_refresh()
	cached_time = " " .. os.date("%Y/%m/%d %H:%M")
	local delay = (60 - tonumber(os.date("%S"))) * 1000
	if delay == 0 then
		delay = 60000
	end
	vim.defer_fn(schedule_time_refresh, delay)
end

local function current_time()
	return cached_time
end

local function line_status()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	return "row:" .. vim.fn.line(".") .. "/" .. vim.fn.line("$") .. " col:" .. (col + 1)
end

local function lsp_status()
	local noice = package.loaded["noice"] and require("noice")
	---@diagnostic disable-next-line: undefined-field
	if noice and noice.api.status.lsp_progress.has() then
		---@diagnostic disable-next-line: undefined-field
		local msg = noice.api.status.lsp_progress.get() or ""
		if #msg > 40 then
			return msg:sub(1, 37) .. "..."
		end
		return msg
	end
	return lsp_clients()
end

local sections = {
	lualine_a = {
		{ "mode" },
	},
	lualine_b = {
		{ "branch" },
	},
	lualine_c = {
		{
			"filename",
			path = 1,
			file_status = true,
			newfile_status = false,
			shorting_target = 40,
			symbols = {
				modified = "[Modified]",
				readonly = "[Readonly]",
				unnamed = "[No name]",
				newfile = "[New]",
			},
		},
		{ "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
		{ "diff", symbols = { added = "+", modified = "*", removed = "-" } },
	},
	lualine_x = {},
	lualine_y = {
		"encoding",
		"filetype",
		{ lsp_status },
	},
	lualine_z = {
		{ line_status },
		{ current_time },
	},
}

return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		schedule_time_refresh()
		require("lualine").setup({
			options = {
				theme = lualine_theme.build,
				always_divide_middle = true,
				globalstatus = true,
				refresh = {
					statusline = 300,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = sections,
			tabline = {},
			extensions = { "nvim-tree", "oil" },
		})

		-- dashboard-nvim restores laststatus=2 on BufEnter after startup (saved before
		-- lualine loads). Re-apply global statusline after dashboard's restore runs.
		local group = vim.api.nvim_create_augroup("LualineGlobalStatus", { clear = true })
		vim.api.nvim_create_autocmd("BufEnter", {
			group = group,
			callback = function()
				if vim.bo.filetype == "dashboard" then
					return
				end
				vim.schedule(function()
					if vim.bo.filetype == "dashboard" then
						return
					end
					if vim.opt.laststatus:get() ~= 3 then
						vim.opt.laststatus = 3
					end
				end)
			end,
		})
	end,
}
