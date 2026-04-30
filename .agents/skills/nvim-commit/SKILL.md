---
name: nvim-commit
description: >
  Create conventional commits for Neovim plugins that are compatible with release-please
  and follow SemVer. Use when the user asks to commit changes, make a git commit,
  or says "/commit" while working in a Neovim plugin project. Analyzes the diff to
  produce correctly scoped, typed commit messages that release-please can parse into
  changelog entries and semantic version bumps. Also use when the user asks about
  commit message format for their Neovim plugin or wants to know what type a change
  should be.
license: MIT
allowed-tools: Bash
---

# Neovim Plugin Conventional Commits

Create semantic git commits for Neovim plugins that release-please can parse into
changelog sections and correct version bumps.

## Why this matters

release-please scans commit messages to decide what goes in the CHANGELOG and whether
to bump the patch, minor, or major version. A poorly scoped or mistyped commit either
gets ignored or ends up in the wrong changelog section. Every commit message is a
contract with the release tooling.

## Conventional Commit Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

The scope is always present — unlike generic conventional commits where scope is
optional, Neovim plugins benefit from always scoping because modules are small and
tightly named. Users reading the changelog need to see at a glance which module changed.

## Commit Types and SemVer Impact

| Type       | Purpose                          | Version Bump | Changelog Section |
| ---------- | -------------------------------- | ------------ | ----------------- |
| `feat`     | New feature or capability        | minor        | Features          |
| `fix`      | Bug fix                          | patch        | Bug Fixes         |
| `perf`     | Performance improvement          | patch        | Performance       |
| `refactor` | Code restructuring (no behavior) | none         | (omitted)         |
| `docs`     | Documentation only               | none         | (omitted)         |
| `style`    | Formatting, whitespace (no logic)| none         | (omitted)         |
| `test`     | Add or update tests              | none         | (omitted)         |
| `build`    | Build system, dependencies       | none         | Build             |
| `ci`       | CI configuration                 | none         | CI                |
| `chore`    | Maintenance, tooling, meta       | none         | (omitted)         |
| `revert`   | Revert a previous commit         | varies       | Reverts           |

## Scopes

The scope identifies the module or area that changed. It should match the Lua module
name under `lua/<plugin>/` as closely as possible, since that's what users recognize
from the changelog.

### Auto-detecting scope from file paths

Map changed files to scopes using these patterns:

| File Path Pattern                        | Scope       |
| ---------------------------------------- | ----------- |
| `lua/<plugin>/init.lua`                  | `init`      |
| `lua/<plugin>/config.lua`                | `config`    |
| `lua/<plugin>/health.lua`                | `health`    |
| `lua/<plugin>/util.lua`                  | `util`      |
| `lua/<plugin>/types.lua`                 | `types`     |
| `lua/<plugin>/<name>.lua`                | `<name>`    |
| `lua/<plugin>/<dir>/<name>.lua`          | `<dir>.<name>` or `<dir>` |
| `doc/<plugin>.txt`                       | `docs`      |
| `README.md`                              | `docs`      |
| `.github/workflows/*`                    | `ci`        |
| `tests/*`                                | test scope or omit |
| `Makefile`, `stylua.toml`, `selene.toml` | omit scope  |

When multiple files span different scopes, pick the scope of the primary change. If
there is no clear primary scope (e.g., a cross-cutting refactor), use the broadest
common scope or omit the scope.

**The `<plugin>` name** is the directory name under `lua/`. Detect it by running
`ls lua/` and using the single directory found there.

### Scope style

- Lowercase, no hyphens or underscores — match the Lua module name as-is
- Examples: `config`, `init`, `util`, `health`, `types`
- For nested modules: `nes.edit`, `cli.prompt`, `terminal`

## Breaking Changes

Breaking changes bump the major version (or minor if pre-1.0). Signal them with `!`
after the type/scope:

```
feat(config)!: rename `disabled` to `enabled`

BREAKING CHANGE: `disabled` option renamed to `enabled` with inverted logic.
Users must update their config.
```

Or use a `BREAKING CHANGE:` footer. Both work with release-please. The footer
style is preferred when the body needs to explain migration steps, since the `!`
style keeps the subject line cleaner.

## Workflow

### 1. Detect the plugin name

```bash
ls lua/
```

The single directory under `lua/` is the plugin name. Use it to detect scopes from
file paths.

### 2. Analyze the diff

```bash
# Staged changes
git diff --staged

# If nothing staged, check working tree
git diff

# File list for scope detection
git diff --name-only --staged || git diff --name-only
```

### 3. Stage files if needed

If nothing is staged, check `git status --porcelain` and stage the changed files.
Group logically related changes together — one commit per concern.

**Never commit**: secrets, `.env`, credentials, private keys.

### 4. Determine type and scope

Read the diff and decide:

- **Type**: based on the nature of the change (new functionality → `feat`, bug fix →
  `fix`, etc.)
- **Scope**: auto-detect from the file paths using the table above
- **Description**: one line, present tense, imperative mood, under 72 characters

### 5. Execute the commit

```bash
# Single line
git commit -m "feat(config): add debounce option for status updates"

# With body
git commit -m "$(cat <<'EOF'
feat(health): add check for deprecated options

Warn users when their config contains keys that were removed
in the latest major version.
EOF
)"

# Breaking change
git commit -m "$(cat <<'EOF'
feat(init)!: require explicit setup() call

BREAKING CHANGE: The plugin no longer auto-starts. Users must
call `require('plugin').setup({})` in their config.
EOF
)"
```

## Writing good descriptions

- Present tense, imperative mood: "add option" not "added option" or "adds option"
- Start with a lowercase letter after the colon: `feat(util): add debounce helper`
- Be specific: "add `debounce` option to config" beats "add new option"
- Keep under 72 characters (the subject line, including type and scope)
- Don't end with a period

## Project files vs local tooling

The `.agents/` directory in this project is version-controlled — it contains skill
definitions that are part of the repo, just like `lua/`, `doc/`, or `tests/`. Treat
files under `.agents/` the same as any other project code when staging and committing.
Do not suggest skipping or excluding them.

## What to avoid

- Don't use `chore` for actual code changes — it won't appear in the changelog
- Don't combine multiple unrelated changes in one commit (release-please can't
  separate them)
- Don't use generic scopes like `core` or `misc` — use the actual module name
- Don't reference issue numbers in the subject line; put them in the body or footer

## Git Safety

- Never update git config
- Never run destructive commands (`--force`, hard reset) without explicit request
- Never skip hooks (`--no-verify`) unless asked
- Never force push to main/master
- If commit fails due to hooks, fix and create a new commit (don't amend)
