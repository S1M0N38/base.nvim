---@tag plugin_name

---@brief [[
---This is a template for a plugin. It is meant to be copied and modified.
---The following code is a simple example to show how to use this template and how to take advantage of code documentation to generate plugin documentation.
---
---This simple example plugin provides a command to calculate the maximum or minimum of two numbers.
---Moreover, the result can be rounded if specified by the user in its configuration using the setup function.
---
--- <pre>
--- `:PluginName {number} {number} {max|min}`
--- </pre>
---
--- The plugin can be configured using the |plugin_name.setup()| function.
---
---@brief ]]

---@class PluginNameModule
---@field setup function: setup the plugin
---@field main function: calculate the max or min of two numbers and round the result if specified by options
local plugin_name = {}

--- Setup the plugin
---@param options Config: config table
---@eval { ['description'] = require('plugin_name.config').__format_keys() }
plugin_name.setup = function(options)
  require("plugin_name.config").__setup(options)
end

--- Calcululate the max or min of two numbers and round the result if specified by options
---@param a number: first number
---@param b number: second number
---@param func string: "max" or "min"
---@return number: result
plugin_name.main = function(a, b, func)
  local options = require("plugin_name.config").options
  local mymath = require("plugin_name.math")
  local result = mymath[func](a, b)
  if options.round then
    result = mymath.round(result)
  end

  local str = "The " .. func .. " of " .. a .. " and " .. b .. " is "
  if options.round then
    str = str .. mymath.round(result) .. " (rounded)"
  else
    str = str .. result
  end
  print(str)

  return result
end

return plugin_name
