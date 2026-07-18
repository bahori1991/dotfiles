-- ================================================================================
-- TITLE: neovim-treesitter/nvim-treesitter
-- ABOUT: manage parser and query
-- LINKS: https://github.com/neovim-treesitter/nvim-treesitter
-- ================================================================================

return {
	"neovim-treesitter/nvim-treesitter",
	dependencies = { "neovim-treesitter/treesitter-parser-registry" },
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local parsers = {
			"markdown",
			"markdown_inline",
			"haskell",
			"html_tags",
			"html",
			"ecma",
			"typescript",
			"javascript",
			"tsx",
			"jsx",
			"css",
			"lua",
			"python",
			"yaml",
			"toml",
			"json",
		}
		local filetypes = {
			"markdown",
			"mdx",
			"haskell",
			"html",
			"typescript",
			"typescriptreact",
			"javascript",
			"css",
			"lua",
			"python",
			"yaml",
			"toml",
			"json",
		}

		vim.api.nvim_create_user_command("TSInstallConfigured", function()
			require("nvim-treesitter").install(parsers)
		end, {})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = filetypes,
			callback = function()
				pcall(vim.treesitter.start)
				-- vim.bo.indentexpr = "v:lua.vim.treesitter.indentexpr()"
			end,
		})
	end,
}
