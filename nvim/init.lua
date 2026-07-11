local scratch_cleanup = require("config.scratch-cleanup")
scratch_cleanup.drop_empty_argv()
scratch_cleanup.setup_autocmds()

require("config.options")
require("config.zenhan")
require("config.lazy")

local function has_startup_files()
  for i = 0, vim.fn.argc() - 1 do
    local arg = vim.fn.argv(i)
    if arg ~= nil and arg ~= "" then
      return true
    end
  end
  return false
end

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    if has_startup_files() then
      return
    end
    vim.schedule(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].filetype == "dashboard" then
          scratch_cleanup.normalize_dashboard_buffer()
          scratch_cleanup.wipe_scratch_buffers()
          return
        end
      end
      local pre_buf = vim.api.nvim_get_current_buf()
      require("dashboard"):instance()
      vim.schedule(function()
        local dash_buf = vim.api.nvim_get_current_buf()
        scratch_cleanup.disable_all_checktime()
        scratch_cleanup.normalize_dashboard_buffer()
        if pre_buf ~= dash_buf and vim.api.nvim_buf_is_valid(pre_buf) then
          scratch_cleanup.clean_scratch_buffer(pre_buf)
        end
        scratch_cleanup.wipe_scratch_buffers()
        scratch_cleanup.schedule_startup_wipes()
      end)
    end)
  end,
})

require("config.lsp")
require("config.keymaps")
require("config.kill-session")
require("config.focus-dim")
