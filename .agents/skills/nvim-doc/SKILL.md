---
name: nvim-doc
description: >
  Write, update, and improve Neovim plugin help documentation (vimdoc) in
  doc/<plugin>.txt. Use when the user asks to write docs, update docs, generate
  the help file, add documentation for a function, or mentions vimdoc, help tags,
  or plugin documentation. Reads the plugin source code to extract API, commands,
  configuration, and other info from LuaCATS annotations and code structure, then
  writes a properly formatted doc/<plugin>.txt following vimdoc conventions. Do not
  use for general Neovim :help lookups (use nvim-help skill instead) or for writing
  README.md, CHANGELOG.md, or other non-vimdoc documentation.
allowed-tools: Bash read edit write
---

# Neovim Plugin Documentation (vimdoc)

This skill writes and updates Neovim plugin help documentation. The output is
`doc/<plugin>.txt` — a plain text file that integrates with Neovim's `:help`
system using the vimdoc format.

## Vimdoc format rules

These rules are derived from Neovim's own help files and established Neovim
plugin documentation. Follow them precisely.

### General

- Text width: 78 characters (set by modeline `tw=78`)
- Section separators: exactly 80 `=` characters, no trailing whitespace, no
  blank line between the separator and the section header that follows it
- Tags: `*like-this*` — lowercase, hyphens for sections, dots for functions
- Cross-references: `|like-this|`
- Indentation within sections and code blocks: 2 spaces
- File must end with the modeline as the last line:
  `vim:tw=78:ts=8:et:ft=help:norl:`

### Section headers

Title in UPPERCASE left-aligned, tag right-aligned, total width 80 chars.
Pad with spaces so `*tag*` ends at column 80. Blank line after the header.

```
INTRODUCTION                                                           *myplug*
FEATURES                                                       *myplug-features*
CONFIGURATION                                                   *myplug-config*
```

### Subsections

Lowercase or title-case followed by `: ~`. The `: ~` suffix distinguishes
subsections from regular text.

```
Using lazy.nvim: ~

Install with...

Common Issues: ~

Issue: Something doesn't work ~
- Try this
```

### Tags

- Sections: `*plugin-section-name*` (lowercase, hyphens)
- Functions: `*plugin.function()*` (includes parens)
- Submodule functions: `*plugin.submodule.function()*`
- Plugin name = directory under `lua/`

Function tags go on a separate line ABOVE the signature, right-aligned:

```
                                                               *myplug.setup()*
myplug.setup({opts}) ~
  Configure the plugin.
```

For submodule functions, show the full require path in the signature:

```
                                                  *myplug.cli.get_blocks()*
require("myplug.cli").get_blocks() ~
  Get raw blocks data.
```

### Cross-references

`|tag-name|` for internal refs, also works for Neovim built-in help tags
(e.g. `|nvim_set_keymap()|`). Every cross-reference must resolve to an
existing tag — broken references are a serious error.

### Table of contents

Inside INTRODUCTION. Numbered list with description and right-aligned tag,
padded so `|tag|` ends near column 80:

```
Table of contents:

1. FEATURES: What this plugin provides.                      |myplug-features|
2. REQUIREMENTS: Plugin dependencies and setup.          |myplug-requirements|
3. INSTALLATION: How to install the plugin.              |myplug-installation|
4. CONFIGURATION: Available options and their defaults.        |myplug-config|
```

### Code blocks

Delimited by `>` (with filetype) and `<` on their own lines. Content
indented 2 spaces. Multiple blocks can appear in sequence with text between:

```
>lua
  require("myplug").setup({
    option = "value",
  })
<

Enable the component:

>lua
  { "some/dep.nvim", opts = { component = "myplug" } }
<
```

Filetypes: `>lua`, `>vim`, `>bash`. Every `>` must have a matching `<`.

### Configuration docs

Show `setup()` signature, then a code block with ALL default options. Each
option has its default value and a comment with description and type:

```
>lua
  {
    name = "default",       -- Description of name (string, default: "default")
    verbose = false,        -- Enable verbose output (boolean, default: false)
    max_count = 10,         -- Maximum items (number, default: 10)
    on_done = nil,          -- Callback when finished (function|nil)
  }
<
```

Read the actual config/defaults module to get real defaults — never guess.

### Command docs

```
:PluginName [args] ~
  Description of what the command does.
  - `subcommand1`: Description
  - `subcommand2`: Description
```

Health check:

```
:checkhealth pluginname ~
  Run health checks. Validates:
  - Plugin installation
  - Configuration validity
```

### Function docs (API)

Strict layout: tag line → signature → description → Parameters → Return →
optional example.

Simple function:
```
                                                               *myplug.hello()*
myplug.hello() ~
  Display a greeting.

  Return format: ~
  "Hello [name]"
```

With parameters:
```
                                                         *myplug.parse.item()*
myplug.parse.item({item}) ~
  Convert a quickfix item to a formatted string.

  Parameters: ~
    {item} (`table`) A quickfix or location list item.

  Return: ~
    `string` The formatted representation.
```

Returning complex data — use a code block:
```
  Return format: ~
>lua
    {
      blocks = {
        { id = "block-id", tokens = 1000, cost = 5.25 },
        -- ... more blocks
      }
    }
<
```

### Requirements

Bullet points with URLs. Optional deps marked with `- optional`:

```
- Neovim >= 0.10
- some-cli (https://example.com) for external tool integration
- lualine.nvim (https://github.com/nvim-lualine/lualine.nvim) - optional
```

### Installation

lazy.nvim as primary example. Include dependencies in the spec if needed.
If the plugin is a template (e.g. the repo has "Use this template" on GitHub),
include the template-based workflow as a subsection before the lazy.nvim
install:

```
Using as a template: ~

1. Click "Use this template" on GitHub to create a new repository
2. Clone your new repository and customize for your plugin:
   - Replace "base" with your plugin name throughout the codebase
   - Replace "S1M0N38" with your GitHub username
   - Update plugin description and functionality
```

After the install code block, optionally break down each field:

```
- `user/myplug.nvim`: The plugin's GitHub repository.
- `version`: Pin to semantic version.
- `opts`: See |myplug.setup()|.
- `dependencies`: Required/optional plugins.
```

### Troubleshooting

Start with health check, then reproduction steps, then common issues:

```
Common Issues: ~

Issue: Something doesn't work ~
- Check step 1
- Verify step 2
```

---

## Workflow

### Step 1 — Discover the plugin

```bash
ls lua/                    # Plugin name = directory name here
find lua/ -name "*.lua" | sort
ls plugin/                 # User commands / lazy-loading
ls doc/                    # Existing docs
```

If no `lua/` directory, use the project directory name, stripping `.nvim`.

### Step 2 — Read the source code

Read plugin source to extract everything needing documentation. Read in this
priority order:

1. **`lua/<plugin>/init.lua`** — Main module, exports, `setup()`
2. **`lua/<plugin>/config.lua`** or **`defaults.lua`** — Default options
   (most reliable source for config docs)
3. **`lua/<plugin>/types.lua`** — LuaCATS type annotations
4. **`plugin/<plugin>.lua`** — User commands, lazy-loading
5. **`lua/<plugin>/health.lua`** — Health check items
6. **Other `lua/<plugin>/*.lua`** — Submodules with public functions
7. **`README.md`** — Description (don't copy verbatim)

What to extract:
- **setup() and config defaults**: options, types, defaults, descriptions
- **Exported functions**: name, params (names + types), return type, behavior
- **User commands**: name, arguments, subcommands, completion
- **Highlight groups**: names, default links, descriptions
- **Autocmds**: events listened to or fired
- **Keymaps**: default keymaps

If LuaCATS annotations are sparse, infer from test files (`tests/`). If still
unclear, ask the user rather than guessing.

### Step 3 — Read existing docs (if updating)

Read `doc/<plugin>.txt` fully before editing. When updating, the goal is
**minimal changes** — only touch what's stale or missing. Treat the existing
doc as the source of truth for style and structure.

- **Preserve existing tag names** — renaming breaks bookmarks and cross-refs
- **Preserve section structure** — never remove sections, even if they seem
  redundant. Only remove entries within a section if the corresponding code
  was deleted. Add new sections where they fit in the canonical order.
- **Preserve narrative text** — explanatory paragraphs, blank lines used
  to separate concepts, and any prose that helps the reader. Don't strip
  these out when updating.
- **Preserve formatting alignment** — keep the same column alignment used
  in the existing doc for ToC entries, section headers, etc.
- **Update stale descriptions** — match current code behavior
- **Add missing docs** — new functions, options, commands
- **Remove obsolete entries** — only functions or options whose code was
  actually deleted

### Step 4 — Write the help file

Follow the format rules above precisely. Use this canonical section order
(omit sections that don't apply):

1. **INTRODUCTION** — `*plugin*` — Description, links, table of contents
2. **FEATURES** — `*plugin-features*` — Feature list. Include this section
   when the plugin has meaningful features to highlight. If the README or
   source code describes features, document them here.
3. **REQUIREMENTS** — `*plugin-requirements*` — Dependencies
4. **INSTALLATION** — `*plugin-installation*` — lazy.nvim install
5. **CONFIGURATION** — `*plugin-config*` — setup() options and defaults
6. **COMMANDS** — `*plugin-commands*` — User commands
7. **KEYMAPS** — `*plugin-keymaps*` — Default keymaps (if any)
8. **HIGHLIGHTS** — `*plugin-highlights*` — Highlight groups (if any)
9. **API** or **FUNCTIONS** — `*plugin-api*` — Public Lua functions
10. **EXAMPLES** — `*plugin-examples*` — Usage patterns (optional)
11. **DEVELOPMENT** — `*plugin-development*` — Testing, building (optional)
12. **TROUBLESHOOTING** — `*plugin-troubleshooting*` — Common issues

### Step 5 — Validate

After writing, verify:
1. Every `|cross-reference|` points to an existing `*tag*`
2. Every `>` has a matching `<`
3. No content line exceeds 78 characters
4. Table of contents matches actual sections
5. Function signatures match the source code
6. No trailing whitespace on blank/separator lines

Quick validation:
```bash
grep -oP '\|[^|]+\|' doc/<plugin>.txt | tr -d '|' | sort -u | while read tag; do
  if ! grep -q "\*${tag}\*" doc/<plugin>.txt; then
    echo "BROKEN REFERENCE: |$tag|"
  fi
done
```

## Writing style

- Concise and factual. Every sentence helps the user do or understand something.
- Present tense: "Displays a greeting" not "Will display a greeting".
- Explain *what* and *why*, not *how* (implementation goes in code comments).
- Show a usage example if the function isn't obvious from its signature.
- Config options always show the default value.
- lazy.nvim as the primary (usually only) installation example.
- Mark optional dependencies clearly.
- Narrative prose is welcome — short paragraphs that explain the purpose of
  a section or connect concepts make the docs more readable. Don't strip
  these when updating an existing doc.
- Use blank lines to separate distinct concepts within a section (e.g.
  between different installed plugins in a lazy.nvim spec). Don't collapse
  these away.
