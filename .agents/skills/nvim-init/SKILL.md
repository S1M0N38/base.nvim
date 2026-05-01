---
name: nvim-init
description: >
  Initialize a Neovim plugin project after cloning from base.nvim template. Run
  once at the start of development to verify the development environment is set up
  correctly. Use when the user says "init", "setup", "initialize", "check environment",
  "nvim-init", or asks to verify their Neovim plugin development setup. Also use when
  the user says they just cloned the template or wants to start developing a Neovim plugin.
  Do not use for general Neovim plugin development tasks (use nvim-plugin) or for
  running tests (use nvim-test).
---

# Neovim Plugin Project Initialization

This skill walks through a checklist to verify that a Neovim plugin development
environment is correctly configured. It writes findings to a state file in the
project root (`.nvim-init.md`) so progress is persisted between sessions.

## Overview

The checklist has a welcome step followed by five execution steps. Each step
collects information and records the result in the state file. If the skill is
interrupted, it reads the state file on the next invocation and resumes from
where it left off.

0. **Welcome** — Display overview and ask user to confirm readiness
1. **Metadata** — Extract plugin name and GitHub username
2. **Requirements** — Verify required tools are installed
3. **Installation** — Check that the plugin and lazydev.nvim are installed in Neovim, and propose/apply config updates if missing
4. **Rename** — Replace template placeholders (`base`, `S1M0N38`) with the user's plugin name and GitHub username across all files, then commit
5. **Docs** — Update README.md, doc/<module>.txt, and rockspec with the user's plugin description, replacing template boilerplate with TODO markers where appropriate

## State file

The state file lives at `.nvim-init.md` in the project root. It doubles as the
progress tracker and the final report.

- On first run: display the welcome message (step 0). Only create the state file
  after the user confirms readiness.
- On resume: read `.nvim-init.md`, find the first unchecked step, and **skip** any
  already-passed steps (don't re-verify them). If the state file exists, skip step 0.
- After each sub-step: update the file with findings (fill in the sections, check off boxes)
- Add `.nvim-init.md` to `.gitignore` so it doesn't pollute the repo

Steps that have sub-checks (like step 3) use indented checkboxes. When resuming,
skip to the first unchecked box at any level.

## Step execution

For each step, read the corresponding reference file and follow its instructions.
Update the state file after completing each step.

| Step | Reference file | What it does |
|------|---------------|--------------|
| 0. Welcome | `references/00-INTRO.md` | Display welcome message and overview, ask user to confirm |
| 1. Metadata | `references/01-METADATA.md` | Extract plugin name from directory, GitHub username from git remote |
| 2. Requirements | `references/02-REQUIREMENTS.md` | Check that neovim, stylua, lua-language-server, git, make are installed |
| 3. Installation | `references/03-INSTALLATION.md` | Find Neovim config, detect plugin manager, detect conventions, verify plugin + lazydev.nvim, propose & apply config updates |
| 4. Rename | `references/04-RENAME.md` | Derive module/command names, rename files and replace content, verify, commit |
| 5. Docs | `references/05-DOCS.md` | Collect plugin description, update README, vimdoc, and rockspec with user's content |

## Severity levels

- **❌ Failure** — a required check did not pass. The user must fix this.
- **⚠️ Warning** — an optional/recommended check did not pass. Suggest the fix
  but don't block progress.
- **✅ Pass** — check passed.

lazydev.nvim is **optional** (⚠️ warning if missing). All other checks are
required (❌ failure if missing).

When a check fails and a config update is needed, the skill **proposes** the
exact changes matching the user's config conventions. The user must explicitly
approve before any changes are applied to their Neovim config.

## Important notes

- Ask the user before proceeding through each step. Don't run the whole checklist
  silently — this is meant to be interactive and educational.
- If something fails, explain why and suggest how to fix it. The user may be new
  to Neovim plugin development.
- The state file uses markdown checkboxes (`- [ ]` / `- [x]`) to track progress.
  Keep the format consistent so resume works reliably.
- Before proposing any config changes, **study the user's existing config** to
  detect their conventions (file naming, spec format, opts vs config, etc.).
  All proposals MUST match these conventions exactly.
- Never modify the user's Neovim config without explicit approval.
- Don't load the plugin in Neovim to verify it works — just check that the config
  entries exist. Loading can have side effects and requires full configuration.

## Completion message

When all 5 steps are complete (all checkboxes checked), display a final message
recapping what was done and suggesting next actions:

---

🎉 **Initialization complete!** Here's what was set up:

- ✅ Plugin metadata extracted
- ✅ Development requirements verified
- ✅ Plugin installed in your Neovim config
- ✅ Template renamed from `base` → `<module>`
- ✅ Documentation updated with your plugin description

**Suggested next steps:**

1. **Review and delete `.nvim-init.md`** — This file tracked progress during
   initialization. Review it if you like, then remove it. It's already in
   `.gitignore` so it won't affect your repo.

2. **Brainstorm your plugin features and generate an `AGENTS.md`** — Tell your
   AI coding agent about your plugin's goals and architecture so it can assist
   you better. ⚠️ **Note:** the current Lua code still comes from the template —
   it contains placeholder logic (`hello()`, `bye()`, etc.). You'll replace it
   as you develop your actual plugin features.

---

Fill in `<module>` with the actual module name from step 4. Adapt the recap
naturally based on what actually happened (e.g., if some steps had warnings).
