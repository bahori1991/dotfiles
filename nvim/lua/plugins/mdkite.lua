-- =====================================================================================================
-- TITLE: selimacerbas/mdkite.nvim
-- ABOUT: Live Markdown preview in the browser (Mermaid, KaTeX, scroll sync)
-- LINKS: https://github.com/selimacerbas/mdkite.nvim
-- =====================================================================================================

return {
  "selimacerbas/mdkite.nvim",
  dependencies = { "selimacerbas/kitehost.nvim" },
  ft = "markdown",
  cmd = "MdKite",
  keys = {
    { "<leader>ms", "<cmd>MdKite start<cr>", desc = "Markdown: Start preview (mdkite)" },
    { "<leader>mS", "<cmd>MdKite stop<cr>", desc = "Markdown: Stop preview (mdkite)" },
    { "<leader>mr", "<cmd>MdKite refresh<cr>", desc = "Markdown: Refresh preview (mdkite)" },
  },
  config = function()
    require("mdkite").setup({
      open_browser = true,
      default_theme = "dark",
      custom_css = vim.fn.stdpath("config") .. "/mdkite.css",
      browser = {
        "/mnt/c/Windows/explorer.exe",
      },
    })
  end,
}
