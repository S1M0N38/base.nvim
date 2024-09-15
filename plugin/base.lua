-- In this file you define the User commands, i.t how the user will interact with your plugin.

local sub_cmds = {
  hello = require("base").hello,
  bye = require("base").bye,
}

local sub_cmds_keys = {}
for k, _ in pairs(sub_cmds) do
  table.insert(sub_cmds_keys, k)
end

local function main_cmd(opts)
  local sub_cmd = sub_cmds[opts.args]
  if sub_cmd == nil then
    vim.print("Base: invalid subcommand")
  else
    sub_cmd()
  end
end

vim.api.nvim_create_user_command("Base", main_cmd, {
  nargs = "?",
  desc = "Base example command",
  complete = function(arg_lead, _, _)
    return vim
      .iter(sub_cmds_keys)
      :filter(function(sub_cmd)
        return sub_cmd:find(arg_lead) ~= nil
      end)
      :totable()
  end,
})

-- RESOURCES:
--  - :help lua-guide-commands-create
--  - https://github.com/nvim-neorocks/nvim-best-practices?tab=readme-ov-file#speaking_head-user-commands
