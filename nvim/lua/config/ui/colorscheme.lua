-- ================================================================================
-- TITLE: colorscheme.lua
-- ABOUT: Shared vscode colorscheme setup and restore
-- ================================================================================

local colors = require("config.ui.colors")

local M = {}

function M.vscode_opts()
	return {
		transparent = true,
		disable_nvimtree_bg = true,
		group_overrides = {
			-- transparent editor (terminal wallpaper shows through)
			Normal = { fg = colors.gray[100], bg = "NONE" },
			-- comments (default vscGreen #6A9955 is too dim on transparent bg)
			Comment = { fg = colors.green[200] },
			SpecialComment = { fg = colors.green[200] },
			["@comment"] = { fg = colors.green[200] },
			EndOfBuffer = { fg = "NONE", bg = "NONE" },
			-- diagnostics (align with config.ui.colors)
			DiagnosticError = { fg = colors.red[500] },
			DiagnosticWarn = { fg = colors.yellow[500] },
			DiagnosticInfo = { fg = colors.blue[500] },
			DiagnosticHint = { fg = colors.blue[500] },
			DiagnosticOk = { fg = colors.cyan[500] },
			DiagnosticUnnecessary = { fg = colors.gray[500] },
			DiagnosticUnderlineError = { fg = "NONE", bg = "NONE", undercurl = true, sp = colors.red[500] },
			DiagnosticUnderlineWarn = { fg = "NONE", bg = "NONE", undercurl = true, sp = colors.yellow[500] },
			DiagnosticUnderlineInfo = { fg = "NONE", bg = "NONE", undercurl = true, sp = colors.blue[500] },
			DiagnosticUnderlineHint = { fg = "NONE", bg = "NONE", undercurl = true, sp = colors.blue[500] },
			-- blink.cmp
			BlinkCmpMenu = { bg = colors.gray[900] },
			BlinkCmpMenuBorder = { bg = colors.gray[900], fg = colors.gray[900] },
			BlinkCmpMenuSelection = { bg = colors.blue[700], fg = colors.blue[200] },
			BlinkCmpScrollBarGutter = { bg = colors.gray[900], fg = colors.gray[900] },
			BlinkCmpScrollBarThumb = { bg = colors.gray[900], fg = colors.gray[900] },
			BlinkCmpDoc = { bg = colors.gray[900] },
			BlinkCmpDocBorder = { bg = colors.gray[900], fg = colors.gray[900] },
			BlinkCmpSignatureHelp = { bg = colors.gray[900] },
			BlinkCmpSignatureHelpBorder = { bg = colors.gray[900], fg = colors.gray[900] },
			-- blink.indent
			BlinkIndent = { fg = colors.gray[500] },
			BlinkIndentBlue = { fg = colors.blue[500] },
			-- blink.pairs
			BlinkPairsBlue = { fg = colors.blue[500] },
			BlinkPairsUnmatched = { fg = colors.red[500] },
			BlinkPairsUnmatchParen = { bg = colors.gray[800], bold = true },
			-- general floating windows (LSP hover, diagnostics, etc.)
			NormalFloat = { bg = colors.gray[900] },
			FloatBorder = { bg = colors.gray[900], fg = colors.gray[700] },
			-- cursor
			vCursor = { bg = colors.orange[500] },
			-- cursor line
			CursorLine = { bg = colors.gray[800] },
			CursorLineNr = { bg = colors.gray[800], fg = colors.yellow[500], bold = true },
			-- nvim-tree (match editor cursor line)
			NvimTreeCursorLine = { bg = colors.blue[700] },
			NvimTreeCursorLineNr = { bg = colors.blue[700], fg = colors.blue[700], bold = true },
			NvimTreeGitFileIgnoredHL = { fg = colors.gray[400] },
			NvimTreeGitFolderIgnoredHL = { fg = colors.gray[400] },
			-- Only gray out gitignored entries; other git statuses keep normal tree colors.
			NvimTreeGitFileDirtyHL = { link = "NvimTreeNormal" },
			NvimTreeGitFileStagedHL = { link = "NvimTreeNormal" },
			NvimTreeGitFileNewHL = { link = "NvimTreeNormal" },
			NvimTreeGitFileDeletedHL = { link = "NvimTreeNormal" },
			NvimTreeGitFileRenamedHL = { link = "NvimTreeNormal" },
			NvimTreeGitFileMergeHL = { link = "NvimTreeNormal" },
			NvimTreeGitFolderDirtyHL = { link = "NvimTreeNormal" },
			NvimTreeGitFolderStagedHL = { link = "NvimTreeNormal" },
			NvimTreeGitFolderNewHL = { link = "NvimTreeNormal" },
			NvimTreeGitFolderDeletedHL = { link = "NvimTreeNormal" },
			NvimTreeGitFolderRenamedHL = { link = "NvimTreeNormal" },
			NvimTreeGitFolderMergeHL = { link = "NvimTreeNormal" },
			-- telescope
			TelescopeSelection = { bg = colors.blue[700], fg = colors.blue[200] },
			TelescopePromptBorder = { fg = colors.blue[500], bg = colors.gray[950] },
			TelescopeResultsBorder = { fg = colors.blue[500], bg = colors.gray[950] },
			TelescopePreviewBorder = { fg = colors.blue[500], bg = colors.gray[950] },
			-- dropbar
			WinBar = { bg = colors.gray[900] },
			WinBarNC = { bg = colors.gray[900] },
			-- Folded
			Folded = { fg = colors.gray[500] },
		},
	}
end

function M.apply_vscode()
	require("vscode").setup(M.vscode_opts())
	require("vscode").load()
end

return M
