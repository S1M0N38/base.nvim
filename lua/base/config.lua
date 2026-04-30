---@class Base.Config
---@field name string
local M = {}

---@class Base.DefaultOptions
local defaults = { name = "John Doe" }

-- Access config values directly: Config.name
local config = vim.deepcopy(defaults)

-- Created at module load — always available
M.augroup = vim.api.nvim_create_augroup("base", { clear = true })
M.ns = vim.api.nvim_create_namespace("base")

setmetatable(M, {
  __index = function(_, key)
    return config[key]
  end,
})

---Extend the defaults options table with the user options
---@param opts? Base.UserOptions plugin options
function M.setup(opts)
  config = vim.tbl_deep_extend("force", {}, vim.deepcopy(defaults), opts or {})

  -- Validate config
  if type(config.name) ~= "string" then
    local Util = require("base.util")
    Util.error(("Invalid 'name' option: expected string, got %s"):format(type(config.name)))
    config.name = defaults.name
  end
end

return M
