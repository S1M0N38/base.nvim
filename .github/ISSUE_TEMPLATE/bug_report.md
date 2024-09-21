---
name: Bug report
about: Create a report to help us improve
title: 'bug: [add the title here]'
labels: bug
assignees: S1M0N38

---

**Test with `minimal.lua`**
[! IMPORTANT]
> Please do not skip this step. For most users, issues occur because of their Neovim configuration.

1. Create the file `repro.lua` with the following content
```lua
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
```
2. Run Neovim using `repro.lua` as config:
```
nvim -u repro.lua
```
3. Reproduce the bug

**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

You can also include screenshot (simply drag and drop image or video in this text area)

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Versions**
 - OS: [e.g. macOS 15.1]
 - Neovim [e.g. 0.10.1]
 - Plugin [e.g. 0.1.1] 

**Additional context**
Add any other context about the problem here.
