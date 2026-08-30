-- ======================================================================================
-- TITLE: saghen/blink.cmp
-- ABOUT: Completion plugin with support for LSPs, cmdline, signature help and snippets.
-- LINKS: https://github.com/saghen/blink.cmp
-- ======================================================================================

return {
	"saghen/blink.cmp",
	version = "1.*",
	event = { "InsertEnter", "CmdlineEnter" },
	---@module "blink.cmp"
	---@type blink.cmp.Config
	dependencies = { "saghen/blink.pairs" },
	opts = {
		keymap = {
			preset = "default",
			["<C-k>"] = false, -- tmux pane up (tmux-navigator)
			["<C-e>"] = {
				function(cmp)
					return cmp.show({ providers = { "lsp" } })
				end,
				"fallback",
			},
			["<C-.>"] = { "show_signature", "hide_signature", "fallback" },
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<CR>"] = {
				function(cmp)
					if cmp.is_menu_visible() then
						return cmp.select_and_accept()
					end
					local keys = require("blink.cmp.keymap.fallback").wrap("i", "<cr>")()
					if not keys then
						keys = vim.api.nvim_replace_termcodes("<cr>", true, true, true)
					end
					return require("config.completion.blink-cr").fix_indent(keys)
				end,
			},
			["<C-CR>"] = { "fallback" },
			["<Up>"] = { "fallback" },
			["<Down>"] = { "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		signature = {
			enabled = true,
			window = {
				scrollbar = false,
				-- Default is { "n", "s" }, which places the popup above the cursor and hides the line you type on.
				-- "s" uses relative = "cursor", row = 1, col = 0 (directly below, left edge at cursor).
				direction_priority = { "s", "n" },
				max_width = 80,
				max_height = 5,
				show_documentation = false,
			},
		},
		completion = {
			keyword = { range = "prefix" },
			accept = { auto_brackets = { enabled = true } },
			list = { selection = { preselect = true, auto_insert = false } },
			ghost_text = { enabled = true },
			menu = {
				scrollbar = false,
				-- blink.cmp puts signature on the opposite side of the completion menu; menu above leaves room below the cursor.
				direction_priority = { "n", "s" },
			},
			documentation = {
				window = {
					scrollbar = false,
				},
			},
		},
		sources = {
			default = { "lazydev", "lsp", "path" },
			providers = {
				buffer = { enabled = false },
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},
		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
	},
	opts_extend = { "sources.default" },
	config = function(_, opts)
		require("blink.cmp").setup(opts)
	end,
}
