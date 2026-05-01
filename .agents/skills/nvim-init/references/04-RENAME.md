# Step 4: Rename Template → Plugin

This step renames every occurrence of the template placeholder (`base`) to the
user's actual plugin name, and replaces the template GitHub username
(`S1M0N38`) with the user's username.

## Prerequisite: clean working tree

Before starting, verify the git working tree is clean:

```bash
git status --porcelain
```

- **Clean** → proceed with the rename.
- **Dirty** → ask the user whether they want to **commit** or **discard**
  their uncommitted changes. Repeat until the tree is clean, then proceed.

## 1. Derive and confirm names

From the metadata collected in step 1, derive three identifiers. Present all
three to the user for confirmation. If the user wants to override any of them,
accept the override and re-validate.

| Identifier | Derivation rule | Used for | Example (`my-cool-plugin.nvim`) |
|---|---|---|---|
| **plugin** | Directory name as-is | README, badges, URLs, rockspec, notify title | `my-cool-plugin.nvim` |
| **module** | Plugin name minus `.nvim`, hyphens → underscores | `require()`, `lua/` dir, augroup, help tags, test files | `my_cool_plugin` |
| **Pascal** | Module name split on `_`, each segment title-cased, then concatenated | User command, LuaCATS class prefix | `MyCoolPlugin` |

Also ask the user for their preferred **command name** (e.g. `:MyPlugin`,
`:Mcp`, `:Scroll`). This cannot be reliably auto-derived because command
names are a matter of taste and brevity.

### Module name validation

The module name MUST satisfy all of these constraints:

- Only lowercase letters, digits, and underscores
- Must start with a letter (not a digit)
- No consecutive underscores
- No leading/trailing underscores
- Must not be a Lua reserved word (`and`, `or`, `not`, `if`, `do`, `end`,
  `for`, `in`, `local`, `nil`, `repeat`, `return`, `then`, `until`, `while`,
  `break`, `else`, `elseif`, `function`, `true`, `false`, `goto`)
- Must not collide with a common stdlib module (`string`, `table`, `io`,
  `math`, `os`, `debug`, `coroutine`, `utf8`, `package`)

If the derived module name violates any constraint, explain why and ask the
user to provide an alternative. If the user provides a custom name, validate
it against the same rules.

## 2. Show the rename plan

Before making any changes, present a summary of everything that will happen.
Group by category:

### Files to rename (mv)

| From | To |
|---|---|
| `lua/base/` | `lua/<module>/` |
| `plugin/base.lua` | `plugin/<module>.lua` |
| `tests/base_spec.lua` | `tests/<module>_spec.lua` |
| `doc/base.txt` | `doc/<module>.txt` |
| `base.nvim-scm-1.rockspec` | `<plugin>-scm-1.rockspec` |

> `tests/health_spec.lua` keeps its filename — only content is updated.

### Content replacements

In **all Lua files** (`lua/`, `plugin/`, `tests/`):

| Pattern | Replacement | Context |
|---|---|---|
| `require("base")` / `require('base')` | `require("<module>")` | module requires |
| `require("base.X")` / `require('base.X')` | `require("<module>.X")` | submodule requires |
| `"base"` (in augroup/namespace) | `"<module>"` | `nvim_create_augroup`, `nvim_create_namespace` |
| `"base.nvim"` (in notify title) | `"<plugin>"` | `vim.notify` title |
| `Base` (LuaCATS class prefix) | `<Pascal>` | `@class Base.Config` → `@class <Pascal>.Config` |
| `"Base: invalid subcommand"` | `"<Pascal>: invalid subcommand"` | error messages |

In **`plugin/<module>.lua`**:

| Pattern | Replacement |
|---|---|
| `"Base"` (user command name) | `"<command>"` |
| `"Base example command"` (desc) | `"<command> example command"` |

In **`doc/<module>.txt`** (vimdoc):

| Pattern | Replacement |
|---|---|
| `*base*` | `*<module>*` |
| `*base-*` (all help tags) | `*<module>-*` |
| `\|base-*\|` (all help refs) | `\|<module>-*\|` |
| `:checkhealth base` | `:checkhealth <module>` |
| `:Base` | `:<command>` |
| `base.nvim` (prose) | `<plugin>` |

In **`README.md`**:

| Pattern | Replacement |
|---|---|
| `base.nvim` | `<plugin>` |
| `S1M0N38` | `<github-username>` |
| `:help base` | `:help <module>` |
| `Base` (command refs) | `<command>` |
| `require("base")` | `require("<module>")` |

In **`CONTRIBUTING.md`**:

| Pattern | Replacement |
|---|---|
| `base.nvim` | `<plugin>` |
| `S1M0N38` | `<github-username>` |
| `MODULE=base` | `MODULE=<module>` |
| `tests/base_spec.lua` | `tests/<module>_spec.lua` |
| `require("base")` | `require("<module>")` |
| `base.setup` / `base.hello` | `<module>.setup` / `<module>.hello` |

In **`repro/repro.lua`**:

| Pattern | Replacement |
|---|---|
| `S1M0N38/base.nvim` | `<github-username>/<plugin>` |
| `base.nvim` (in comments) | `<plugin>` |
| `:checkhealth base` | `:checkhealth <module>` |

In **rockspec** (`<plugin>-scm-1.rockspec`):

| Pattern | Replacement |
|---|---|
| `S1M0N38` | `<github-username>` |
| `base.nvim` | `<plugin>` |
| `base.nvim is a simple template...` | keep text as-is (will be updated in step 5) |

In **LICENSE**:

| Pattern | Replacement |
|---|---|
| `Copyright (c) 2025 S1M0N38` | `Copyright (c) <year> <github-username>` |

### Files NOT touched

- `.agents/` — template tooling, not part of the plugin
- `.tests/` — cache artifacts
- `.luarc.json` — no `base` references
- `Makefile` — no hardcoded `base`
- `.github/workflows/` — no `base` or `S1M0N38` references
- `tests/minit.lua` — no `base` references
- `CHANGELOG.md` — leave as-is (will be deleted in step 5)
- `LICENSE` — updated in this step (copyright holder)

## 3. Execute the rename

Ask the user for final confirmation, then execute in this order:

### a. File renames

```bash
mv lua/base lua/<module>
mv plugin/base.lua plugin/<module>.lua
mv tests/base_spec.lua tests/<module>_spec.lua
mv doc/base.txt doc/<module>.txt
mv base.nvim-scm-1.rockspec <plugin>-scm-1.rockspec
```

### b. Content replacements

Use `sed` (or equivalent) to perform the replacements described in section 2.
Work through each file systematically. **Order matters** — replace longer
strings before shorter ones to avoid partial matches. Recommended order:

1. `require("base.` → `require("<module>.` (submodules first)
2. `require("base")` → `require("<module>")`
3. `S1M0N38` → `<github-username>` (before `base.nvim` to avoid double-replace)
4. `base.nvim` → `<plugin>` (full plugin name before bare `base`)
5. `"base"` (augroup/namespace) → `"<module>"`
6. `Base` (LuaCATS/classes) → `<Pascal>`
7. Help tags and vimdoc-specific patterns in `doc/<module>.txt`
8. Command names in `plugin/<module>.lua`

> **Important**: Use word-boundary-aware matching where possible. The string
> `base` appears inside words like `database` — only replace standalone
> occurrences that refer to the template name. After each file, inspect the
> result to catch false positives.

## 4. Verify

After all renames and replacements, run a verification sweep:

```bash
# Check for leftover template references (excluding .agents/, .tests/, CHANGELOG)
rg -l "S1M0N38" --glob '!.agents/**' --glob '!.tests/**' --glob '!CHANGELOG.md'
rg -l 'require\("base' --glob '!.agents/**' --glob '!.tests/**'
rg -l 'require\('"'"'base' --glob '!.agents/**' --glob '!.tests/**'
```

- **No matches** → proceed to commit.
- **Matches found** → report them to the user, fix, and re-verify.

## 5. Commit

Use the **nvim-commit** skill to create the commit. The commit message should
be:

```
refactor!: rename template placeholders to <plugin>
```

This is a `refactor!` (breaking) because it changes every module path — any
existing `require("base")` calls will break, which is expected for a fresh
template customization.

## Recording

Update the state file's checklist:

```markdown
- [ ] 4. Template renamed
  - [ ] 4a. Names derived and confirmed
  - [ ] 4b. Rename plan approved
  - [ ] 4c. Files renamed and content replaced
  - [ ] 4d. Verification passed (no leftover references)
  - [ ] 4e. Changes committed
```

Fill in the rename section:

```markdown
## Rename

- **Plugin name**: `<plugin>`
- **Module name**: `<module>`
- **Pascal prefix**: `<Pascal>`
- **Command name**: `:<command>`
- **GitHub username**: `<github-username>`
- **Verification**: ✅ / ❌
```
