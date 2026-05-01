# Step 5: Update Documentation

This step replaces the template's documentation boilerplate with the user's
actual plugin description. It updates README.md, the vimdoc, and the rockspec.

## 1. Collect plugin description

Ask the user:

1. **Tagline** — A one-sentence description of what the plugin does.
   (e.g. "Smooth scrolling with customizable easing curves")
2. **Description** — A longer paragraph explaining the plugin's purpose and
   key features. (1–3 sentences)

Present the user's tagline alongside 2–3 proposed variations. The user picks
one (or keeps their original). The chosen tagline is used in README, vimdoc
INTRODUCTION, and rockspec `summary`.

## 2. Update README.md

### Sections to keep and update

- **Title and badges** — Replace `base.nvim` with `<plugin>`, replace
  `S1M0N38` with `<github-username>` in badge URLs. Remove the Reddit badge
  (template-specific). Update the tagline subtitle.
- **📦 Installation** — Keep the section structure. Update all plugin name
  references to `<plugin>`. Replace `require("base")` with
  `require("<module>")`. Update lazydev library reference from `"base.nvim"`
  to `"<plugin>"`.

### Sections to replace with TODO markers

Replace the content of these sections with an HTML comment TODO containing the
original section heading, preserving the section heading itself:

- **💡 Motivation** → `<!-- TODO: describe what problem your plugin solves and why it exists -->`
- **⚡ Requirements** → `<!-- TODO: list your plugin's requirements (Neovim version, external tools, etc.) -->`
- **🚀 Usage** → `<!-- TODO: add usage examples, configuration snippets, and screenshots -->`
- **🙏 Acknowledgments** → `<!-- TODO: credit libraries, plugins, or people that inspired or helped -->`

### Sections to remove entirely

- **🤖 AI Coding Agent** — This is a template-specific section. Remove it
  completely (no TODO marker).

### Section order after update

1. Title + badges + tagline
2. 💡 Motivation (TODO)
3. ⚡ Requirements (TODO)
4. 📦 Installation (kept/updated)
5. 🚀 Usage (TODO)

### Installation section template

```markdown
## 📦 Installation

Install using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "<github-username>/<plugin>",
  lazy = false,
  opts = {},
}
```

For development, see [CONTRIBUTING.md](CONTRIBUTING.md).
```

Adapt the installation snippet to the plugin manager detected in step 3 if
the user doesn't use lazy.nvim.

## 3. Update doc/<module>.txt (vimdoc)

Preserve the section structure (headers, tags, separator lines) but replace
template-specific content with TODO markers. The result should look like:

```
================================================================================
INTRODUCTION                                                      *<module>*

<plugin> — <tagline>

<!-- TODO: Add a brief introduction to your plugin. Explain what it does
and link to relevant resources. -->

Links:
- Changelog: https://github.com/<github-username>/<plugin>/blob/main/CHANGELOG.md
- License (MIT): https://github.com/<github-username>/<plugin>/blob/main/LICENSE

Table of contents:

1. FEATURES: What this plugin provides.                    |<module>-features|
2. REQUIREMENTS: Plugin dependencies and setup.        |<module>-requirements|
3. INSTALLATION: How to install.                       |<module>-installation|
4. CONFIGURATION: Available options.                        |<module>-config|
5. COMMANDS: Commands provided.                            |<module>-commands|
6. API: Exposed functions.                                     |<module>-api|

================================================================================
FEATURES                                                   *<module>-features*

<!-- TODO: Describe the main features of your plugin. -->

================================================================================
REQUIREMENTS                                           *<module>-requirements*

<!-- TODO: List the requirements for your plugin. -->

... (same pattern for each section) ...
```

Keep the final modeline: `vim:tw=78:ts=8:et:ft=help:norl:`

## 4. Update rockspec description

In `<plugin>-scm-1.rockspec`, update:

```lua
description = {
    summary = "<tagline>",
    detailed = [[
<plugin> — <description>
    ]],
    labels = { "neovim", "plugin", "lua" },
    ...
}
```

Replace the template's labels with appropriate ones for the user's plugin.
If the user can't provide labels, keep a minimal set: `"neovim"`, `"plugin"`,
`"lua"`.

## 5. Delete template CHANGELOG.md

The existing `CHANGELOG.md` contains the template's changelog history, which is
not relevant to the user's new plugin. Delete it:

```bash
rm CHANGELOG.md
```

release-please will automatically generate a fresh `CHANGELOG.md` when it
creates the first release.

Also remove any references to `CHANGELOG.md` that point to the template's
history (e.g. in vimdoc "Links" section, the changelog URL should stay but
the file itself is gone — this is fine, release-please will recreate it).

## 6. Regenerate help tags

After updating `doc/<module>.txt`, regenerate the tags file:

```bash
nvim --headless -c "helptags doc/" -c "q"
```

This creates/updates `doc/tags` so `:help <module>` works.

## 7. Commit

Use the **nvim-commit** skill to create the commit:

```
docs!: replace template documentation with plugin description
```

## Recording

Update the state file:

```markdown
## Docs

- **Plugin tagline**: `<tagline>`
- **README updated**: ✅
- **Vimdoc updated**: ✅
- **Rockspec updated**: ✅
- **CHANGELOG.md deleted**: ✅
- **Help tags regenerated**: ✅
- **Changes committed**: ✅
```

Check off all sub-steps in the checklist.
