vim.api.nvim_create_user_command("PluginName", function(args)
  local a, b, func = unpack(args.fargs)
  a = tonumber(a)
  b = tonumber(b)
  assert(a, "a must be a number")
  assert(b, "b must be a number")
  require("plugin_name").main(a, b, func)
end, { nargs = "+" })
