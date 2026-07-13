-- ================================================================================
-- TITLE: kill-session
-- ABOUT: kill tmux session only when :qa / :qall is executed
-- ================================================================================

local M = { should_kill = false }

local function is_qa_cmd(cmd)
  cmd = vim.trim(cmd)
  return cmd == "qa" or cmd == "qa!" or cmd == "qall" or cmd == "qall!"
end

local function can_kill_tmux_session()
  if vim.env.NVIM_IN_TMUX ~= "1" then
    return false
  end
  if #vim.api.nvim_list_uis() == 0 then
    return false
  end
  return true
end

local group = vim.api.nvim_create_augroup("KillSession", { clear = true })

vim.api.nvim_create_autocmd("QuitPre", {
  group = group,
  callback = function()
    if is_qa_cmd(vim.fn.histget(":", -1)) then
      M.should_kill = true
    end
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  group = group,
  callback = function()
    if M.should_kill and can_kill_tmux_session() then
      os.execute("tmux kill-session -t nvim-dev 2>/dev/null")
    end
    M.should_kill = false
  end,
})
