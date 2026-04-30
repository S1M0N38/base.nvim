---@meta _
--- Definition file for LuaLS type information. Not loaded at runtime.
--- See: https://luals.github.io/wiki/definition-files/

-- lua/base/init.lua -----------------------------------------------------------

---@class Base.Plugin
---@field did_setup boolean whether setup() has been called
---@field setup fun(opts?: Base.UserOptions) setup the plugin with user options
---@field hello fun(): string Say hello to the user using configured name
---@field bye fun(): string Say goodbye to the user using configured name

-- lua/base/config.lua ---------------------------------------------------------

---@class Base.Config
---@field augroup integer augroup created at module load
---@field ns integer namespace created at module load
---@field setup fun(opts?: Base.UserOptions) setup the plugin configuration

---@class Base.UserOptions
---@field name? string The name of the user to greet (optional)

---@class Base.DefaultOptions
---@field name string The default name of the user to greet

---@class Base.Options
---@field name string The name of the user to greet (merged from user/default options)

-- lua/base/util.lua -----------------------------------------------------------

---@class Base.Util
---@field notify fun(msg: string|table, level?: integer) send notification with plugin title
---@field info fun(msg: string) send info notification
---@field warn fun(msg: string) send warning notification
---@field error fun(msg: string) send error notification

-- lua/base/health.lua ---------------------------------------------------------

---@class Base.Health
---@field check fun() perform health check for the plugin
