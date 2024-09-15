---@class Config
local M = {}

---@class DefaultOptions
M.defaults = { name = "John Doe" }

---@class Options
M.options = {}

---Extend the defaults options table with the user options
---@param opts UserOptions: plugin options
M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
end

return M
