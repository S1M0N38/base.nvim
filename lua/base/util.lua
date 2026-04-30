---@class Base.Util
local M = {}

---Send a notification with plugin title, scheduled to avoid fast-event issues
---@param msg string|table message to display
---@param level integer vim.log.levels value
function M.notify(msg, level)
  msg = type(msg) == "table" and table.concat(msg --[[@as table]], "\n") or msg --[[@as string]]
  vim.schedule(function()
    vim.notify(msg --[[@as string]], level or vim.log.levels.INFO, { title = "base.nvim" })
  end)
end

---@param msg string
function M.info(msg)
  M.notify(msg, vim.log.levels.INFO)
end

---@param msg string
function M.warn(msg)
  M.notify(msg, vim.log.levels.WARN)
end

---@param msg string
function M.error(msg)
  M.notify(msg, vim.log.levels.ERROR)
end

return M
