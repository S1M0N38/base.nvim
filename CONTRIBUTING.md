# Contributing to base.nvim

Thank you for your interest in contributing to base.nvim! This template aims to provide a good foundation for Neovim plugin development.

## Getting Started

1. **Read the documentation**: Start with the [README](README.md) and comprehensive [help documentation](doc/base.txt)
2. **Set up your environment**: Clone the repo and install the dev dependencies (see below)
3. **Test your setup**: Run `make check` to verify everything works

## Development Setup

### Prerequisites

| Tool | Version | Required for | Install |
|------|---------|--------------|---------|
| [Neovim](https://github.com/neovim/neovim) | ≥ 0.12.2 | tests, dev | [releases](https://github.com/neovim/neovim/releases) |
| [StyLua](https://github.com/JohnnyMorganz/StyLua) | 2.4.1 | lint, format | [releases](https://github.com/JohnnyMorganz/StyLua/releases) |
| [lua-language-server](https://github.com/LuaLS/lua-language-server) | latest | type annotations in editor | [releases](https://github.com/LuaLS/lua-language-server/releases) |

### Clone and verify

```bash
git clone https://github.com/S1M0N38/base.nvim.git
cd base.nvim
make check
```

Tests auto-install their dependencies ([mini.test](https://github.com/echasnovski/mini.test) + [luassert](https://github.com/lunarmodules/luassert)) via [lazy.minit](https://github.com/folke/lazy.nvim) on first run. No manual setup required.

## Make Targets

| Target | Description |
|--------|-------------|
| `make test` | Run all tests |
| `make test-one MODULE=base` | Run a single test file (`tests/base_spec.lua`) |
| `make lint` | Check formatting with StyLua (`--check`) |
| `make format` | Auto-format Lua files with StyLua |
| `make check` | Run lint + test |
| `make dev` | Launch Neovim with repro config for manual testing |

## Writing Tests

Tests use [mini.test](https://github.com/echasnovski/mini.test) managed by [lazy.minit](https://github.com/folke/lazy.nvim). Write tests in busted-style `describe`/`it` with `luassert` assertions.

### Test structure

```
tests/
├── minit.lua         # Bootstrap entry point (lazy.minit)
├── base_spec.lua     # Plugin logic tests
└── health_spec.lua   # Health check tests
```

### Example test

```lua
---@module 'luassert'

local base = require("base")
base.setup({})

describe("default options", function()
  it("hello() returns greeting with default name", function()
    assert.are.equal("Hello John Doe", base.hello())
  end)
end)
```

### Running tests

```bash
make test                          # All tests
make test-one MODULE=base          # Only tests/base_spec.lua
nvim -l tests/minit.lua --minitest tests/base_spec.lua  # Explicit file
```

## GitHub Workflow

### Fork and Clone

1. Fork this repository on GitHub
2. Clone your fork locally:

```bash
git clone https://github.com/your-username/base.nvim.git
cd base.nvim
```

### Create a Branch

```bash
git checkout -b feature/add-awesome-feature
# or
git checkout -b fix/specific-bug-description
```

### Make Your Changes

1. **Write tests**: Add or update tests in the `tests/` directory
2. **Update documentation**: Update `doc/base.txt` and README if needed
3. **Follow coding standards**: Run `make format` before committing

### Commit and Push

Use [conventional commits](https://www.conventionalcommits.org/) for automatic versioning:

```bash
git add .
git commit -m "feat: add awesome new feature"
git push origin feature/add-awesome-feature
```

**Commit types:**
- `feat:` — New features (minor version bump)
- `fix:` — Bug fixes (patch version bump)
- `docs:` — Documentation changes
- `test:` — Adding or updating tests
- `refactor:` — Code refactoring without behavior changes

### Submit a Pull Request

1. Go to your fork on GitHub
2. Click "New Pull Request"
3. Provide a clear title and description
4. Reference any related issues

## CI

Two GitHub Actions workflows run automatically:

| Workflow | Trigger | Jobs |
|----------|---------|------|
| `ci.yml` | Push/PR to `main` | StyLua lint, lua-language-server typecheck, tests (stable + nightly) |
| `release.yml` | Push to `main` | release-please (changelog + GitHub release), LuaRocks publish |

## Bug Reports

When reporting bugs, please:

1. **Use the reproduction environment**: Test with `repro/repro.lua` (`make dev`)
2. **Fill out the issue template**: Provide all requested information
3. **Include steps to reproduce**: Clear, step-by-step instructions

## Development Notes

- **Template focus**: Remember this is a template — changes should benefit all plugin developers
- **Keep it simple**: Avoid adding complex dependencies or patterns
- **Document everything**: Both code comments and help documentation

Thank you for helping make base.nvim better! 🚀
