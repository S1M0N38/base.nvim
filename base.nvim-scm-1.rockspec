---@diagnostic disable: lowercase-global

local _MODREV, _SPECREV = "scm", "-1"
rockspec_format = "3.0"
version = _MODREV .. _SPECREV

local user = "S1M0N38"
package = "base.nvim"

description = {
	summary = "Modern template for Neovim plugin development",
	detailed = [[
base.nvim is a simple template for Neovim plugin development that provides
best practices, testing setup, type definitions, and automated workflows.
  ]],
	labels = { "neovim", "template", "plugin", "lua", "testing", "busted" },
	homepage = "https://github.com/" .. user .. "/" .. package,
	license = "MIT",
}

dependencies = {
	"lua >= 5.1",
}

test_dependencies = {
	"nlua",
}

source = {
	url = "git://github.com/" .. user .. "/" .. package,
}

build = {
	type = "builtin",
}
