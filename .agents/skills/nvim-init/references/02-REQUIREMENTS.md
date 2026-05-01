# Step 2: Requirements Verification

This step checks that all required development tools are installed and meet
the minimum version requirements.

## Tools to check

| Tool | Minimum version | Command |
|------|----------------|---------|
| Neovim | ≥ 0.12.2 | `nvim --version \| head -1` |
| StyLua | any | `stylua --version` |
| LuaLS (lua-language-server) | any | `lua-language-server --version` |
| git | any | `git --version` |
| make | any | `make --version \| head -1` |

## How to check

For each tool, run `which <tool>` to confirm existence, then the version
command from the table above.

## Recording

For each tool, record the result in the state file's Requirements table:

- ✅ `<tool> <version>` if found and version meets requirement
- ❌ `<tool> — not found` or `— version <X> does not meet minimum <Y>`

If any tool is missing, tell the user what to install and pause. Let them
install it and resume later (the state file will remember where you are).
