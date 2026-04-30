---@class Base.Health
local M = {}

---Validate the options table obtained from merging defaults and user options
local function validate_opts_table()
  local opts = require("base.config")

  local ok, err = pcall(function()
    vim.validate({
      name = { opts.name, "string" },
      --- validate other options here...
    })
  end)

  if not ok then
    vim.health.error("Invalid setup options: " .. err)
  else
    vim.health.ok("opts are correctly set")
  end
end

---This function is used to check the health of the plugin
---It's called by `:checkhealth` command
---@return nil
function M.check()
  vim.health.start("base.nvim health check")

  -- Check setup was called
  if require("base").did_setup then
    vim.health.ok("setup() was called")
  else
    vim.health.error("setup() was not called. Call require('base').setup({}) in your config.")
  end

  validate_opts_table()

  -- Add more checks:
  --  - check for requirements
  --  - check for Neovim options (e.g. python support)
  --  - check for other plugins required
  --  - check for LSP setup
  --  ...
end

return M
