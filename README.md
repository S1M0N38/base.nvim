<div align="center">
  <h1>⛶&nbsp;&nbsp;base.nvim&nbsp;&nbsp;⛶ </h1>

  <p align="center">
    <a href="https://github.com/S1M0N38/base.nvim/actions/workflows/ci.yml">
      <img alt="CI badge" src="https://img.shields.io/github/actions/workflow/status/S1M0N38/base.nvim/ci.yml?style=for-the-badge&label=CI"/>
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

A minimal Neovim plugin is just a `lua/` directory and a `plugin/` autocommand. But a maintainable one needs tests, docs, types, CI, and a release workflow. base.nvim fills that gap — no framework, no abstraction, just the smallest possible set of opinionated defaults that work.

Starting a plugin shouldn't mean reinventing project structure and CI pipelines from scratch. base.nvim bundles the conventions used in production plugins so you can focus on writing plugin logic from day one:

- Proper directory layout following [nvim-best-practices](https://github.com/nvim-neorocks/nvim-best-practices)
- LuaCATS type annotations with LuaLS checking
- mini.test + luassert test suite
- StyLua formatting and linting
- CI with lint, typecheck, and test (stable + nightly)
- Automated releases via release-please with GitHub and LuaRocks publishing
- Health checks and vimdoc documentation
- **Agent Skills for AI-assisted development** (`.agents/skills/`)

> [!NOTE]
> **v3.0** ships with built-in Agent Skills for AI coding agents. Plugins derived from this template now include specialized skills for plugin development, testing, documentation, and commit conventions. See the [AI Coding Agent](#-ai-coding-agent) section for details.


## ⚡️ Requirements

- **[Neovim](https://github.com/neovim/neovim)** ≥ 0.12.2
- **[StyLua](https://github.com/JohnnyMorganz/StyLua)**: code formatting and linting
- **[LuaLS](https://github.com/LuaLS/lua-language-server)**: type checking via LuaCATS annotations
- **[git](https://git-scm.com/)**: version control and lazy.nvim bootstrap
- **[Make](https://www.gnu.org/software/make/)**: task runner for build and test commands

Optional:
- **[lazydev.nvim](https://github.com/folke/lazydev.nvim)**: Lua LSP configuration for plugin development

## 📦 Installation

1. Ensure you have requirements installed
2. Click **"Use this template"** → **"Create a new repository"** at the top of this page.
3. Choose a name with the `.nvim` extension (e.g., `your-plugin.nvim`).
4. Clone your new repository and `cd` into it.
5. Install `your-plugin.nvim` using your preferred plugin manager and configure Neovim for plugin development:

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
      "your-plugin.nvim",
    }
  },
}
```

## 🤖 AI Coding Agent

This template ships with [Agent Skills](https://agentskills.io/) in `.agents/skills/`, providing specialized instructions for AI coding agents. Skills follow the [Agent Skills specification](https://agentskills.io/specification) — the same `SKILL.md` format works across [many agents](https://agentskills.io/clients) (e.g. [pi](https://github.com/mariozechner/pi-coding-agent), [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [GitHub Copilot](https://github.blog/changelog/2025-12-18-github-copilot-now-supports-agent-skills/), [Cursor](https://cursor.com/), [Amp](https://ampcode.com/)). Note that agents discover skills from different directories (e.g. `.claude/skills/`, `.github/skills/`). If your agent doesn't pick them up, try renaming `.agents/` to its expected directory (e.g. `mv .agents .claude` for Claude Code).

| Skill | Description |
| --- | --- |
| `nvim-init` | Initialize plugin project and verify development environment |
| `nvim-plugin` | Plugin development best practices and patterns |
| `nvim-test` | Execute tests and diagnose failures |
| `nvim-doc` | Write and update vimdoc help documentation |
| `nvim-commit` | Create conventional commits for release-please |
| `nvim-help` | Search Neovim's built-in `:help` documentation |

## 🚀 Usage

Get started by reading the comprehensive documentation with [`:help base`](https://github.com/S1M0N38/base.nvim/blob/main/doc/base.txt), which covers all plugin features and configuration options.

> [!NOTE]
> Most Vim/Neovim plugins include built-in `:help` documentation. If you're new to this, start with `:help` to learn the basics.

## 🙏 Acknowledgments

- [nvim-best-practices](https://github.com/nvim-neorocks/nvim-best-practices): Collection of DOs and DON'Ts for modern Neovim Lua plugin development
- [nvim-lua-plugin-template](https://github.com/nvim-lua/nvim-lua-plugin-template/): another template for Neovim Lua plugins
- [LuaCATS annotations](https://luals.github.io/wiki/annotations/): type annotations to your Lua code
- [mini.test](https://github.com/echasnovski/mini.test): minimal test framework with child-process isolation
