<div align="center">
  <h1>⛶&nbsp;&nbsp;base.nvim&nbsp;&nbsp;⛶ </h1>

  <p align="center">
    <a href="https://github.com/S1M0N38/base.nvim/actions/workflows/run-tests.yml">
      <img alt="Run Tests badge" src="https://img.shields.io/github/actions/workflow/status/S1M0N38/base.nvim/run-tests.yml?style=for-the-badge&label=Tests"/>
    </a>
    <a href="https://luarocks.org/modules/S1M0N38/base.nvim">
      <img alt="LuaRocks badge" src="https://img.shields.io/luarocks/v/S1M0N38/base.nvim?style=for-the-badge&color=5d2fbf"/>
    </a>
    <a href="https://github.com/S1M0N38/base.nvim/releases">
      <img alt="GitHub badge" src="https://img.shields.io/github/v/release/S1M0N38/base.nvim?style=for-the-badge&label=GitHub"/>
    </a>
    <a href="https://www.reddit.com/r/neovim/comments/195q8ai/template_for_writing_neovim_plugin/">
      <img alt="Reddit badge" src="https://img.shields.io/badge/post-reddit?style=for-the-badge&label=Reddit&color=FF5700"/>
    </a>
  </p>
  <p><em>A template for writing Neovim plugins</em></p>
</div>

______________________________________________________________________

## 💡 Motivation

<!-- TODO: write moitivation -->


## ⚡️ Requirements

- **[Neovim](https://github.com/neovim/neovim)** ≥ 0.11
- **[luarocks](https://luarocks.org/)**: install Lua packages
- **[busted](https://lunarmodules.github.io/busted/)**: unit testing framework for Lua
- **[nlua](https://github.com/mfussenegger/nlua)**: Neovim as Lua interpreter
- **[lazy.nvim](https://github.com/folke/lazy.nvim)**: plugin manager for Neovim
- **[lazydev.nvim](https://github.com/folke/lazydev.nvim)** (optional): enhanced plugin dev experience.
- **[Claude Code](https://github.com/S1M0N38/Claude-Code)** (optional): for automatic plugin initialization

> Here are my personal scripts to install Lua dev packages on macOS: [install.sh](https://gist.githubusercontent.com/S1M0N38/44c573db63864bcd1dc0bfc73359fec9/raw/d92e3b3e5f3da1c8557e93250e6e8a7de0f7d09a/install-lua-luarocks-on-macos.sh) and [uninstall.sh](https://gist.githubusercontent.com/S1M0N38/44c573db63864bcd1dc0bfc73359fec9/raw/d92e3b3e5f3da1c8557e93250e6e8a7de0f7d09a/uninstall-lua-luarocks-on-macos.sh). Use at your own risk!

## 📦 Installation

1. Ensure you have requirements installed
2. Click **"Use this template"** → **"Create a new repository"** at the top of this page.
3. Choose a name with the `.nvim` extension (e.g., `your-plugin.nvim`).
4. Clone your new repository and `cd` into it.
5. Manually follow the initialization steps in [`init-from-template.md`](/.claude/commands/init-from-template.md) or run `claude init-from-template`.
6. Install `your-plugin.nvim` using your preferred plugin manager and configure Neovim for plugin development:

```lua
-- Install and configure your plugin during development
{
  "your-plugin.nvim",
  dir = "/path/to/your-plugin.nvim", -- So we are using the local version of the plugin
  branch = "main", -- Select the branch of the plugin to use
  lazy = false,
  opts = {},
  keys = {
    {
      "<leader>rb", -- Choose a key binding for reloading the plugin
      "<cmd>Lazy reload your-plugin.nvim<cr>",
      desc = "Reload your-plugin.nvim",
      mode = { "n", "v" },
    },
  },
}

-- Enable Lua language server support external libraries
{
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      "${3rd}/luassert/library",
      "${3rd}/busted/library",
      "your-plugin.nvim",
    }
  },
}
```

## 🚀 Usage

Get started by reading the comprehensive documentation with [`:help base`](https://github.com/S1M0N38/base.nvim/blob/main/doc/base.txt), which covers all plugin features and configuration options.

> [!NOTE]
> Most Vim/Neovim plugins include built-in `:help` documentation. If you're new to this, start with `:help` to learn the basics.

## 🙏 Acknowledgments

- [nvim-best-practices](https://github.com/nvim-neorocks/nvim-best-practices): Collection of DOs and DON'Ts for modern Neovim Lua plugin development
- [nvim-lua-plugin-template](https://github.com/nvim-lua/nvim-lua-plugin-template/): another template for Neovim Lua plugins
- [LuaCATS annotations](https://luals.github.io/wiki/annotations/): type annotations to your Lua code
- [Plugin development walkthrough](https://youtu.be/n4Lp4cV8YR0?si=lHlxQBNvbTcXPhVY) by [TJ DeVries](https://github.com/tjdevries): it uses plenary instead of busted for testing
