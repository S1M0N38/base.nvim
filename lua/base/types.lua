---@meta
--- This is a simple "definition file" (https://luals.github.io/wiki/definition-files/),
--- the @meta tag at the top is its hallmark.

-- lua/base/init.lua -----------------------------------------------------------

---@class Base.Plugin
---@field setup function setup the plugin with user options
---@field hello function Say hello to the user using configured name
---@field bye function Say goodbye to the user using configured name

-- lua/base/config.lua ---------------------------------------------------------

---@class Base.Config
---@field defaults Base.DefaultOptions default plugin options
---@field options Base.Options merged user and default options
---@field setup function setup the plugin configuration

---@class Base.UserOptions
---@field name? string The name of the user to greet (optional)

---@class Base.DefaultOptions
---@field name string The default name of the user to greet

---@class Base.Options
---@field name string The name of the user to greet (merged from user/default options)

-- lua/base/health.lua ---------------------------------------------------------

---@class Base.Health
---@field check fun(): nil perform health check for the plugin
