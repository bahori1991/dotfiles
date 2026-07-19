return {
	-- ui
	{ import = "plugins.ui.dashboard" },
	{ import = "plugins.ui.which-key" },
	{ import = "plugins.ui.vscode" },
	{ import = "plugins.ui.lualine" },
	{ import = "plugins.ui.dropbar" },
	{ import = "plugins.ui.nvim-scrollbar" },
	{ import = "plugins.ui.nerdicons" },
	-- navigation
	{ import = "plugins.navigation.oil" },
	{ import = "plugins.navigation.nvim-tree" },
	{ import = "plugins.navigation.telescope" },
	{ import = "plugins.navigation.tmux-navigator" },
	{ import = "plugins.navigation.lazygit" },
	-- syntax
	{ import = "plugins.syntax.nvim-treesitter" },
	-- editing
	{ import = "plugins.editing.dial" },
	{ import = "plugins.editing.neoscroll" },
	{ import = "plugins.editing.vim-doge" },
	{ import = "plugins.editing.nvim-surround" },
	-- completion
	{ import = "plugins.completion.blink" },
	{ import = "plugins.completion.blink-indent" },
	{ import = "plugins.completion.blink-pairs" },
	-- lsp
	{ import = "plugins.lsp.mason" },
	{ import = "plugins.lsp.mason-lspconfig" },
	{ import = "plugins.lsp.mason-tool-installer" },
	{ import = "plugins.lsp.nvim-lspconfig" },
	{ import = "plugins.lsp.conform" },
	{ import = "plugins.lsp.nvim-lint" },
	{ import = "plugins.lsp.lazydev" },
	{ import = "plugins.lsp.typescript-tools" },
}
