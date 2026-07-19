-- ================================================================================
-- TITLE: monaqa/dial.nvim
-- ABOUT: Extend increment/decrement plugin for Neovim
-- LINKS: https://github.com/monaqa/dial.nvim
-- ================================================================================

return {
	"monaqa/dial.nvim",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"<leader>+",
			function()
				require("dial.map").manipulate("increment", "normal")
			end,
			mode = { "n", "v" },
			desc = "Adjust: increment",
		},
		{
			"<leader>G+",
			function()
				require("dial.map").manipulate("increment", "gnormal")
			end,
			mode = { "n", "v" },
			desc = "Adjust: increment (dot repeat)",
		},
		{
			"<leader>-",
			function()
				require("dial.map").manipulate("decrement", "normal")
			end,
			mode = { "n", "v" },
			desc = "Adjust: decrement",
		},
		{
			"<leader>G-",
			function()
				require("dial.map").manipulate("decrement", "gnormal")
			end,
			mode = { "n", "v" },
			desc = "Adjust: decrement (dot repeat)",
		},
	},
	config = function()
		local augend = require("dial.augend")
		require("dial.config").augends:register_group({
			default = {
				augend.integer.alias.decimal,
				augend.integer.alias.hex,
				augend.date.alias["%Y/%m/%d"],
				augend.date.alias["%m/%d"],
				augend.date.alias["%-m/%-d"],
				augend.date.alias["%Y-%m-%d"],
				augend.date.alias["%Y年%-m月%-d日"],
				augend.date.alias["%Y年%-m月%-d日(%ja)"],
				augend.date.alias["%H:%M:%S"],
				augend.date.alias["%H:%M"],
				augend.constant.alias.ja_weekday,
				augend.constant.alias.ja_weekday_full,
				augend.constant.alias.bool,
				augend.semver.alias.semver,
				augend.constant.new({
					elements = { "&&", "||" },
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = { "local", "dev", "qa", "stg", "prd" },
					word = false,
					cyclic = true,
				}),
				augend.case.new({
					types = {
						"camelCase",
						"snake_case",
						"PascalCase",
						"kebab-case",
						"SCREAMING_SNAKE_CASE",
					},
					cyclic = true,
				}),
			},
		})
	end,
}
