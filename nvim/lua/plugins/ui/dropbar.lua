-- ================================================================================
-- TITLE: Bekaboo/dropbar.nvim
-- ABOUT: IDE-like breadcrmbs, out of the box
-- LINKS: https://github.com/Bekaboo/dropbar.nvim
-- ================================================================================

return {
	"Bekaboo/dropbar.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
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
				return vim.bo[buf].bt == "terminal"
					or vim.bo[buf].ft == "markdown"
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
				relative_to = function(buf, win)
					local bufname = vim.api.nvim_buf_get_name(buf)
					if vim.startswith(bufname, "oil://") or vim.startswith(bufname, "fugitive://") then
						local root = bufname:gsub("^%S+://", "", 1)
						while root and root ~= vim.fs.dirname(root) do
							root = vim.fs.dirname(root)
						end
						return root
					end
					local ok, cwd = pcall(vim.fn.getcwd, win)
					return ok and cwd or vim.fn.getcwd()
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
