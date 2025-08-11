Initialize a new Neovim plugin project from this template repository.

Transform this generic template into a personalized starting point for your Neovim plugin by collecting project information and updating all relevant files with your plugin's name and details.

### Prerequisites Check

Before initialization, verify that required development tools are installed:

- `git --version` - Version control (required)
- `luarocks --version` - Lua package manager for dependencies
- `lua -v` - Lua interpreter (5.1+ recommended for Neovim compatibility)
- `busted --version` - Lua testing framework
- `stylua --version` - Lua code formatter
- `lua-language-server --version` - Lua language server

The command will check for these tools and provide a error message if any are missing.
If there is a missing tool, stop the initialization process.

### Project Information Collection

The command will gather the following information:

1. **Plugin Name**: Extract from git remote URL or prompt user
2. **GitHub Owner**: Extract from git remote URL
3. **Plugin Description**: Prompt user for a brief description
4. **Author Information**: Use git config for author name and email

### Transformation Process

1. **Prerequisites Validation**
   - Check for required development tools
   - Verify git repository is properly configured
   - Ensure this is the template repository (not already initialized)

2. **Analyze Current State**
   - Scan for template-specific files and directories
   - Check existing rockspec configuration
   - Verify current file structure matches template

3. **Collect Project Information**
   - Extract repository name from `git remote get-url origin`
   - Extract owner from remote URL
   - Get author info from `git config user.name` and `git config user.email`
   - Prompt for plugin description if needed

4. **Update Project Structure**
   - Rename directories containing "base" to plugin name
   - Update `lua/base/` directory to `lua/{plugin-name}/`
   - Rename rockspec file: `base.nvim-scm-1.rockspec` → `{plugin-name}-scm-1.rockspec`
   - Rename documentation: `doc/base.txt` → `doc/{plugin-name}.txt`

5. **Update File Contents**
   - Replace "base.nvim" with actual plugin name in all files
   - Replace "base" module references with plugin name
   - Update package names in Lua files
   - Update documentation references and help tags
   - Update rockspec metadata (name, description, homepage)
   - Update README.md with plugin-specific information
   - Update GitHub workflow files if present
   - Update configs in workflow
   - Remove the file CHANGELOG.md if it exists

7. **Validate Changes**
   - Ensure all file references are consistent
   - Verify Lua syntax is still valid
   - Check that rockspec is properly formatted
   - Run lua formatter `stylua .` to ensure code is formatted
   - All tests should pass. Run `busted .` to run all tests

8. Summary
    - The command will create a new commit with all the initialization changes
    - Tell the user to configure secrets for workflows on GitHub (returned the variables to configure)
    - User should review changes before running the /commit command to finalize the changes

### Files to Update

- `README.md` - Plugin name, description, installation instructions
- `base.nvim-scm-1.rockspec` - Rename and update metadata
- `lua/base/` directory - Rename to `lua/{plugin-name}/`
- `lua/base/init.lua` - Update module references
- `lua/base/types.lua` - Update module references and documentation
- `doc/base.txt` - Rename to `doc/{plugin-name}.txt` and update content
- `.github/workflows/` - Update CI configuration if present
- Test files in `spec/` - Update require statements

### Notes

- This command should only be run once on a fresh clone of the template
- Requires git repository to be properly configured with remote
- Will create a new commit with all the initialization changes running the command /commit
