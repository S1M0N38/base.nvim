# Contributing to base.nvim

Thank you for your interest in contributing to base.nvim! This template aims to provide a good foundation for Neovim plugin development.

## Getting Started

1. **Read the documentation**: Start with the [README](README.md) and comprehensive [help documentation](doc/base.txt)
2. **Set up your environment**: Follow the installation steps in the README
3. **Test your setup**: Run `:checkhealth base` to verify everything works

## GitHub Workflow

### Fork and Clone

1. Fork this repository on GitHub

2. Clone your fork locally:

```bash
git clone https://github.com/your-username/base.nvim.git
cd base.nvim
```

### Create a Branch

Create a descriptive branch for your changes:
```bash
git checkout -b feature/add-awesome-feature
# or
git checkout -b fix/specific-bug-description
```

### Make Your Changes

1. **Write tests**: Add or update tests for your changes in the `spec/` directory
2. **Update documentation**: Update `doc/base.txt` and README if needed
3. **Follow coding standards**: The project uses EditorConfig - your editor should automatically format code correctly

### Test Your Changes

Before submitting, ensure everything works:

```bash
# Run all tests
busted

# Check health functionality
nvim -u repro/repro.lua -c "checkhealth base" -c "q"

# Format code (uses .editorconfig settings)
stylua .
```

### Commit and Push

Use [conventional commits](https://www.conventionalcommits.org/) for automatic versioning:

```bash
git add .
git commit -m "feat: add awesome new feature"
git push origin feature/add-awesome-feature
```

**Commit types:**
- `feat:` - New features (minor version bump)
- `fix:` - Bug fixes (patch version bump)
- `docs:` - Documentation changes
- `test:` - Adding or updating tests
- `refactor:` - Code refactoring without behavior changes

### Submit a Pull Request

1. Go to your fork on GitHub
2. Click "New Pull Request"
3. Provide a clear title and description
4. Reference any related issues

## Bug Reports

When reporting bugs, please:

1. **Use the reproduction environment**: Test with `repro/repro.lua`
2. **Fill out the issue template**: Provide all requested information
3. **Include steps to reproduce**: Clear, step-by-step instructions
4. **Share artifacts**: Include any logs or error messages from `.repro/`

See our [bug report template](.github/ISSUE_TEMPLATE/bug_report.md) for details.

## Development Notes

- **Template focus**: Remember this is a template - changes should benefit all plugin developers
- **Keep it simple**: Avoid adding complex dependencies or patterns
- **Document everything**: Both code comments and help documentation

Thank you for helping make base.nvim better! 🚀
