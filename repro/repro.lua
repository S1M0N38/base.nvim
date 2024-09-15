-- repro/repro.lua serves as a reproducible environment for your plugin.
-- Whwn user want to open a new ISSUE, they are asked to reproduce their issue in a clean minial environment.
-- repro directory is a safe place to mess around with various config without affecting your main setup.
--
-- 1. Clone base.nvim and cd into base.nvim/repro
-- 2. Run `nvim -u repro/repro.lua`
-- 3. Reproduce the issue
-- 4. Report the repro.lua and logs from .repro directory in the issue
--

vim.env.LAZY_STDPATH = ".repro"
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()


local plugins = {
  {
    "S1M0N38/base.nvim",
    lazy = false,
    opts = {},
  },
}

require("lazy.minit").repro({ spec = plugins })

-- Add additional setup here ...

-- RESOURCES:
--   - https://lazy.folke.io/developers#reprolua
