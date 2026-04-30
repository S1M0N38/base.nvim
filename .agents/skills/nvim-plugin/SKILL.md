---
name: nvim-plugin
description: >
  Neovim plugin development best practices and patterns. Use when planning, editing,
  implementing, or reviewing Neovim Lua plugin code — structuring a new plugin,
  writing setup/config, highlights, autocmds, keymaps, health checks, type annotations,
  debounce, state management, or user commands. Also use when the user asks about
  plugin architecture, conventions, or "how should I implement" a Neovim plugin feature.
  Do not use for general Lua development unrelated to Neovim plugins, Neovim
  configuration (init.lua), or running/debugging tests (use nvim-test).
---

# Neovim Plugin Development

This skill provides patterns and best practices for Neovim plugin development.
Read the reference files below on demand based on the current task.

## Reference Files

Read these on demand based on the task. Do NOT load all three at once.
Each file has a table of contents at the top with anchors for navigation.

### `references/RECIPES.md`
Complete code examples for every plugin pattern.

1. Project Structure
2. Setup & Configuration
3. Module Organization
4. Plugin File (user commands, lazy loading)
5. Highlight Groups
6. Autocmds
7. Keymaps
8. Health Checks
9. Error Handling & Notifications
10. Type Annotations
11. Debounce
12. State Management (per-buffer cache)
13. User Commands (subcommands with completion)
14. Anti-Patterns

### `references/TYPES.md`
LuaCATS type annotation reference for Neovim plugins.

1. Quick Start (minimum annotations every plugin needs)
2. Type Syntax Reference (primitives, compound types, Neovim-specific)
3. Annotation Tags — Complete Reference (@class, @field, @type, @alias, @enum, @param, @return, @generic, @overload, @operator, @cast, visibility modifiers)
4. Neovim Plugin Type Patterns (autocmd callbacks, keymaps, highlights, buffers, LSP, commands)
5. Definition Files (@meta)
6. Config Type Patterns (separate classes vs partial)
7. Diagnostic Configuration (.luarc.json settings)

### `references/TESTS.md`
Testing patterns for writing and implementing tests (mini.test + luassert).
For running tests and diagnosing failures, use the `nvim-test` skill.

1. Test File Structure
2. Assertions Quick Reference
3. Table-Driven Tests
4. Stubbing and Restoring
5. Creating Test Buffers
6. Testing with File Buffers
7. Testing Config Changes
8. Conditional Tests
9. Testing Notifications
10. Testing Highlights
11. Testing Autocmds
12. Testing Keymaps
13. Test Anti-Patterns
14. Advanced Testing Patterns

## Working with existing plugins

When modifying an existing plugin:

1. Read the existing code first — match the project's conventions
2. Check `CONTRIBUTING.md` and `AGENTS.md` for project-specific rules
3. Look at existing `_spec.lua` files to match testing style
4. Look at existing highlight/autocmd patterns and be consistent

## File locations in this project

- Plugin source: `lua/base/`
- Tests: `tests/`
- Plugin commands: `plugin/base.lua`
- Documentation: `doc/base.txt`
