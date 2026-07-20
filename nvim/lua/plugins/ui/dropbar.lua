-- ================================================================================
-- TITLE: Bekaboo/dropbar.nvim
-- ABOUT: IDE-like breadcrmbs, out of the box
-- LINKS: https://github.com/Bekaboo/dropbar.nvim
-- ================================================================================

local anchor = require("config.navigation.nvim-tree-anchor")

return {
	"Bekaboo/dropbar.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		bar = {
			hover = false,
			enable = function(buf, win, _)
				buf = vim._resolve_bufnr(buf)
				if
					not vim.api.nvim_buf_is_valid(buf)
					or not vim.api.nvim_win_is_valid(win)
					or vim.fn.win_gettype(win) ~= ""
					or vim.wo[win].winbar ~= ""
					or vim.bo[buf].bt ~= ""
					or vim.bo[buf].ft == "help"
					or vim.bo[buf].ft == "dashboard"
					or vim.bo[buf].ft == "NvimTree"
				then
					return false
				end
				local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
				if stat and stat.size > 1024 * 1024 then
					return false
				end
				return vim.bo[buf].ft == "markdown"
					or pcall(vim.treesitter.get_parser, buf)
					or not vim.tbl_isempty(vim.lsp.get_clients({
						bufnr = buf,
						method = "textDocument/documentSymbol",
					}))
			end,
		},
		symbol = {
			on_click = false,
		},
		sources = {
			path = {
				relative_to = function(buf)
					local bufname = vim.api.nvim_buf_get_name(buf)
					if vim.startswith(bufname, "oil://") or vim.startswith(bufname, "fugitive://") then
						local root = bufname:gsub("^%S+://", "", 1)
						while root and root ~= vim.fs.dirname(root) do
							root = vim.fs.dirname(root)
						end
						return root
					end
					return anchor.get_anchor_root()
				end,
			},
		},
	},
	config = function(_, opts)
		require("dropbar").setup(opts)
		vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
			pattern = { "dashboard", "NvimTree" },
			callback = function()
				vim.wo.winbar = ""
			end,
		})
	end,
}
