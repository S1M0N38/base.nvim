# Step 3: Installation Verification & Config Proposal

This step verifies that the user has correctly installed the plugin under
development into their Neovim configuration, and that lazydev.nvim is also
configured. If anything is missing, the skill **proposes the exact changes**
needed in the user's config — using the conventions already present in their
config files. The final sub-step is to propose, apply, or skip config updates.

## 1. Find the config directory

Ask the user whether they use a custom `NVIM_APPNAME` for Neovim (e.g. an alias
like `alias nvim='NVIM_APPNAME=lazyvim nvim'` that points Neovim to a separate
config directory). Don't ask for the command/alias itself — aliases don't work
in the agent's bash session.

Based on the answer:

- **No custom appname** — the config directory is the default:
  ```bash
  nvim --headless -c "echo stdpath('config')" -c "q" 2>&1
  ```
- **Custom appname** — resolve the config directory with `NVIM_APPNAME` set:
  ```bash
  NVIM_APPNAME=<appname> nvim --headless -c "echo stdpath('config')" -c "q" 2>&1
  ```

If the user provides a custom `NVIM_APPNAME`, **record it in the state file** so
it can be reused if the skill resumes in a later session. All subsequent commands
that need to interact with Neovim (e.g. checking installed plugins, running
health checks) must use `NVIM_APPNAME=<appname> nvim ...`.

## 2. Detect the plugin manager

Scan the config directory for signatures of known plugin managers. Look for
these indicator patterns:

| Plugin manager | Signature |
|---------------|-----------|
| **lazy.nvim** | `require("lazy")` or `require("lazy").setup(...)` in init files |
| **vim.pack (built-in)** | `vim.pack.add(...)` in init files (Neovim ≥ 0.12 native package manager) |
| **packer.nvim** | `require("packer").startup(...)` or `require("packer")` in init files |
| **vim-plug** | `call plug#begin(...)` or `Plug` commands in init files |
| **mini.deps** | `require("mini.deps").setup(...)` in init files |
| **rocks.nvim** | `rocks.toml` file in config directory |
| **paq-nvim** | `require("paq")(...)` in init files |
| **Legacy packages** | Plugins in `~/.local/share/nvim/site/pack/*/start/` (no manager) |

Use rg to search for these patterns in the config directory:

```bash
rg -l "require\(['\"]lazy['\"]\)" <config-dir>/
rg -l "vim\.pack\.add" <config-dir>/
rg -l "require\(['\"]packer['\"]\)" <config-dir>/
rg -l "plug#begin" <config-dir>/
rg -l "require\(['\"]mini\.deps['\"]\)" <config-dir>/
find <config-dir>/ -name "rocks.toml"
rg -l "require\(['\"]paq['\"]\)" <config-dir>/
```

If no manager is detected, ask the user which one they use. It's possible they
use a manager not in this list or the legacy package system.

## 3. Detect the user's config conventions

Before proposing any config changes, study the user's existing config to match
their style. This is critical — the proposal should look like it belongs in
their config, not like a copy-paste from a tutorial.

### What to look for

1. **File organization** — Where do plugin specs live?
   ```bash
   find <config-dir>/lua -type f -name "*.lua" | sort
   ```
   - LazyVim-style: `lua/plugins/*.lua` with each file returning a spec table
   - Single file: all plugins in one `init.lua` or `plugins.lua`
   - Module-based: `lua/config/plugins/*.lua` with a central loader

2. **Spec style** — How are plugin specs written?
   Read 2–3 existing plugin files to detect patterns:
   ```bash
   # For lazy.nvim
   rg "return\s*\{" <config-dir>/lua/plugins/ -l
   head -20 <some-plugin-file>.lua
   ```
   Key questions:
   - Does each file `return { ... }` a spec table? (lazy.nvim / LazyVim style)
   - Are specs passed to a `setup()` call? (packer style)
   - Are specs defined with `use` / `Plug` / `add` function calls?
   - Is `opts = {}` used for configuration? (lazy convention)
   - Is `config = function() ... end` used? (packer / manual style)

3. **dev settings** — For lazy.nvim, check if `dev.path` and `dev.patterns` are
   already configured:
   ```bash
   rg "dev\s*=\s*\{" <config-dir>/
   ```
   If the user has `dev = { path = "~/Developer", patterns = { "S1M0N38" } }`,
   the proposal should add the GitHub username to `patterns` rather than using
   `dir = "..."` on each plugin spec.

4. **lazydev.nvim presence** — Is lazydev.nvim already installed?
   ```bash
   rg "lazydev" <config-dir>/ -l
   ```

5. **Import patterns** — How are plugin files loaded?
   ```bash
   rg "import" <config-dir>/lua/config/lazy.lua 2>/dev/null
   rg "import" <config-dir>/init.lua 2>/dev/null
   ```
   For lazy.nvim, check the `spec` section for `{ import = "..." }` entries.

### Record conventions

Keep a mental (or written) note of the conventions found. All proposed changes
MUST follow these conventions exactly. If the user uses LazyVim with
`return { "author/plugin", opts = {} }` style, then every proposal must follow
that exact format.

## 4. Verify the plugin is installed

Using the plugin name from Step 1, search the Neovim config for the plugin
installation:
```bash
rg "<plugin-name>" <config-dir>/
```

### What counts as "installed"

#### lazy.nvim
The plugin spec exists with either:
- `dev = true` (uses `config.dev.path` + plugin name as directory)
- `dir = "/absolute/path/to/plugin"` (explicit local path)
- A GitHub spec like `"username/plugin-name.nvim"` (not local — wrong for dev)

#### vim.pack (built-in, Neovim ≥ 0.12)
`vim.pack.add(...)` includes a spec with the plugin name or URL.

#### packer.nvim
`use { "username/plugin-name", ... }` or `use("/path/to/plugin")`.

#### vim-plug
`Plug 'username/plugin-name'` or `Plug '/path/to/plugin'`.

#### mini.deps
`add("username/plugin-name")` or `add({ source = "/path/to/plugin" })`.

#### rocks.nvim
Plugin listed in `rocks.toml`.

#### paq-nvim
`{ "username/plugin-name" }` in the paq setup.

#### Legacy packages
Plugin is symlinked or copied to `~/.local/share/nvim/site/pack/*/start/<name>`.

## 5. Verify lazydev.nvim is installed

lazydev.nvim configures the Lua language server to understand plugin libraries.
Search for it in the same config:

```bash
rg "lazydev" <config-dir>/
```

Check that the plugin under development is listed in lazydev's `library` option.
The library entry can be:
- A string: `"plugin-name"` (resolved relative to plugin dirs)
- A string with absolute path: `"/Users/you/Developer/plugin-name"`
- A table: `{ path = "plugin-name", words = {...}, mods = {...} }`

## 6. Propose config updates

If the plugin is NOT installed in the config, or lazydev.nvim is missing, or
the library entry is missing — **propose the exact changes** the user should
make to their config. Present the proposal and ask if they'd like to apply it.

**CRITICAL**: The proposal MUST follow the conventions detected in step 3.
Match the user's style exactly — file naming, spec format, opts vs config,
return style, indentation, everything.

### How to propose

For each missing piece, show:
1. **Which file** to create or modify (matching the user's file organization)
2. **The exact content** to add (matching the user's spec style)
3. A brief explanation of what the change does

Present all proposals together so the user can review before applying.

### Plugin installation proposals by manager

#### lazy.nvim

**Option A — Using `dev = true` (recommended)**

If the user already has `dev.patterns` configured, just add the username:
```lua
-- In the lazy.setup() call, update dev.patterns:
dev = { path = "~/Developer", patterns = { "existing-author", "<github-username>" } },
```

Then add a plugin spec file (in the user's plugin directory):
```lua
-- lua/plugins/<plugin-name>.lua
return {
  "<github-username>/<plugin-name>",
  dev = true,
  lazy = false, -- always load during development
  opts = {}, -- add plugin options here
}
```

**Option B — Using `dir`**

If the user doesn't use `dev.patterns`, use an explicit path:
```lua
-- lua/plugins/<plugin-name>.lua
return {
  "<github-username>/<plugin-name>",
  dir = "<project-absolute-path>",
  lazy = false,
  opts = {},
}
```

#### vim.pack (built-in, Neovim ≥ 0.12)

For local plugin development, use `vim.cmd.packadd()` with a symlink:

1. Symlink the plugin to a local package directory:
   ```bash
   mkdir -p ~/.local/share/nvim/site/pack/local/opt
   ln -s <project-path> ~/.local/share/nvim/site/pack/local/opt/<plugin-name>
   ```

2. In the config (wherever `vim.pack.add` calls live):
   ```lua
   -- Load local plugin instead of vim.pack.add for the remote version
   vim.cmd.packadd('<plugin-name>')
   -- After loading, require and configure:
   require('<plugin-name>').setup({})
   ```

#### packer.nvim

```lua
-- In the packer startup function:
use {
  '<github-username>/<plugin-name>',
  -- For local development, use the absolute path:
  dir = '<project-absolute-path>',
  config = function()
    require('<plugin-name>').setup({})
  end,
}
-- Or simply:
-- use '<project-absolute-path>'
```

#### vim-plug

```vim
" In the plug#begin/plug#end block:
" Use an absolute path for local development:
Plug '<project-absolute-path>'
```

In Lua init:
```lua
vim.fn['plug#']('<project-absolute-path>')
```

#### mini.deps

```lua
-- Where MiniDeps.add() calls are made:
MiniDeps.add({
  source = '<github-username>/<plugin-name>',
  -- For local dev, use the checkout path:
  checkout = '<project-absolute-path>',
})
-- Or with a local-only name:
MiniDeps.add({ source = '<project-absolute-path>' })
```

#### rocks.nvim

Add to `rocks.toml`:
```toml
[plugins]
"<plugin-name>" = { dir = "<project-absolute-path>" }
```

#### paq-nvim

```lua
-- In the paq setup:
paq {
  '<github-username>/<plugin-name>',
  -- For local dev:
  -- '<project-absolute-path>',
}
```

#### Legacy packages

```bash
# Symlink to the start directory for auto-loading:
ln -s <project-path> ~/.local/share/nvim/site/pack/local/start/<plugin-name>
```

### lazydev.nvim installation proposal

If lazydev.nvim is not installed, propose installing it **alongside** the
plugin. The exact format depends on the user's plugin manager and conventions.

#### With lazy.nvim

Create or modify a file for lazydev (follow the user's file naming — e.g.
`lua/plugins/lazydev.lua`):

```lua
return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Add the plugin being developed so LuaLS understands it
        { path = "<plugin-name>", words = {} },
      },
    },
  },
}
```

If lazydev.nvim is already installed but the plugin is missing from `library`,
propose adding just the library entry. Read the existing lazydev config file
and show the diff:

```lua
-- Add this line inside the existing library = { ... } table:
{ path = "<plugin-name>", words = {} },
```

**Tip**: With lazy.nvim's `dev = true`, lazydev.nvim can also resolve the
library by plugin name automatically. If `dev = true` is used and
`dev.path` points to the right directory, adding `"<plugin-name>"` to the
library is enough — lazydev will find it via lazy.nvim's plugin resolution.

#### With other plugin managers

lazydev.nvim requires lazy.nvim as a plugin manager OR a plugin manager that
uses Neovim's native package system. If the user uses a different manager,
suggest they install lazydev.nvim via their manager and configure it manually:

```lua
-- After loading lazydev.nvim:
require("lazydev").setup({
  library = {
    "<plugin-name>",
  },
})
```

If their manager doesn't support lazy loading by filetype, they can call
`require("lazydev").setup()` directly in their lua config after the plugin
loads.

## Recording

Fill in the installation section of the state file. Check off each sub-checkbox
as you go:

```markdown
## Installation

- **NVIM_APPNAME**: `default` (or custom appname)
- **Config directory**: `/path/to/config`
- **Plugin manager**: lazy.nvim (or whichever was detected)
- **Config conventions**: (brief note about style)
- **Plugin installed**: ✅ / ❌ (with details)
- **lazydev.nvim installed**: ✅ / ⚠️ (optional, warn if missing)
- **lazydev library configured**: ✅ / ⚠️ (optional, warn if missing)
- **Config update proposed**: ✅ / ⏭️ (skipped if everything is configured)
```

If any check fails, **propose the exact config change** following the user's
conventions. Ask if they want to apply it. If they decline, note it in the
state file and continue — don't block progress.

For lazydev.nvim checks, use ⚠️ since it's optional. For the plugin installation
check, use ❌ since the plugin must be installed for development to work.

## Applying proposals

When the user agrees to apply a proposal:

1. **Create or modify** the target file in their config directory
2. Follow the detected conventions exactly
3. If modifying an existing file, use the same indentation and formatting
4. After applying, re-verify the check that was failing
5. Update the state file

If the user declines, note it in the state file and continue. They can always
apply the changes manually later.

**IMPORTANT**: Never modify the user's Neovim config without explicit approval.
Always show the proposal first and ask for confirmation. If the user's config
uses a structure you're unsure about, ask for clarification rather than guessing.
