# Step 1: Metadata Extraction

This step collects identifying information about the plugin: its name and the
GitHub username of the owner.

## Plugin name

The plugin name comes from the project directory name. It should follow the
convention of ending in `.nvim`.

```
basename $(git rev-parse --show-toplevel)
```

If the directory name doesn't end in `.nvim`, note this as a warning — it's not
strictly required but it's the Neovim ecosystem convention. Let the user decide
whether to rename.

## GitHub username

Try these in order:

1. **From git remote origin** — Parse the owner from the remote URL:
   ```bash
   git remote get-url origin
   ```
   The URL can be in either format:
   - `https://github.com/OWNER/REPO.git` → OWNER
   - `git@github.com:OWNER/REPO.git` → OWNER

2. **Ask the user** — If there's no remote or the URL doesn't contain GitHub,
   ask the user directly for their GitHub username.

## Recording

Fill in the metadata section of the state file:

```markdown
## Metadata

- **Plugin name**: `<name>`
- **GitHub username**: `<username>`
- **Repository**: `https://github.com/<username>/<name>`
```
