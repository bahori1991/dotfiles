-- ================================================================================
-- TITLE: folke/noice.nvim
-- ABOUT: replaces the UI for messages, cmdline and the popupmenu
-- LINKS: https://github.com/folke/noice.nvim
-- ================================================================================

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			opts = {
				background_colour = "#000000",
			},
		},
	},
	opts = {
		cmdline = {
			enabled = true,
			view = "cmdline_popup",
		},
		views = {
			cmdline_popup = {
				position = {
					row = "50%",
					col = "50%",
				},
			},
		},
		status = {
			lsp_progress = { event = "lsp", kind = "progress" },
		},
		routes = {
			{
				filter = { event = "lsp", kind = "progress" },
				opts = { skip = true },
			},
		},
		presets = {
			bottom_search = false,
			command_palette = false,
			long_message_to_split = true,
		},
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
		},
	},
	config = function(_, opts)
		require("noice").setup(opts)
		pcall(require("telescope").load_extension, "noice")

		vim.api.nvim_create_autocmd("LspProgress", {
			callback = function()
				vim.cmd("redrawstatus")
			end,
		})

		vim.keymap.set("n", "<leader>nd", "<cmd>Noice dismiss<cr>", { desc = "Dismiss notifications" })
	end,
}
