---@class Base.Config
local M = {}

---@class Base.DefaultOptions
M.defaults = { name = "John Doe" }

---@class Base.Options
M.options = {}

---Extend the defaults options table with the user options
---@param opts Base.UserOptions: plugin options
M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
end

return M
