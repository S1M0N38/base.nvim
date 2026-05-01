# Step 0: Welcome

This step displays the welcome message and gives the user an overview of what
the initialization process will do.

## Welcome message

Display the following to the user (adapt the wording naturally):

---

👋 Welcome to the **base.nvim** plugin initialization!

This wizard will walk you through setting up your Neovim plugin project in
**5 steps**:

| Step | What happens |
|------|-------------|
| **1. Metadata** | Extract your plugin name and GitHub username from the repository |
| **2. Requirements** | Verify that Neovim, StyLua, LuaLS, git, and make are installed |
| **3. Installation** | Set up your Neovim config so the plugin and lazydev.nvim are loaded during development |
| **4. Rename** | Replace every template placeholder (`base`, `S1M0N38`) with your plugin's actual name |
| **5. Docs** | Update README, vimdoc, and rockspec with your plugin's description |

Each step asks for your confirmation before making changes. You can interrupt
at any time and resume later — progress is saved to `.nvim-init.md`.

---

After displaying the overview, ask: **"Ready to start?"**

- If the user confirms → proceed to step 1 (Metadata).
- If the user declines → stop. The state file is not created yet.

## State file

Do NOT create the state file (`.nvim-init.md`) until the user confirms.
Once confirmed, copy the template from `assets/template.md` to `.nvim-init.md`
in the project root, then proceed to step 1.
