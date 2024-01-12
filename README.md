# My Awesome Plugin

A simple way to kickstart your Neovim plugin development like a pro:

## Plugin Structure

- `plugin/plugin_name.lua` - *the main file, the one loaded by the plugin manager*

- `lua/plugin_name/`

  - `init.lua` - *the main file of the plugin, the one loaded by the `plugin/plugin_name.lua`*
  - `math.lua` - *an example of module, here we define simple math functions*
  - `config.lua` - *store plugin default options and extend them with user's ones*

- `tests/pluin_name/`

  - `plugin_name_spec.lua` - *plugin tests. Add here other `*_spec.lua` for further testing*

- `scripts/`

  - `docs.lua` - *Lua script to auto-generate `doc/plugin_name.txt` docs file from code annotations*
  - `minimal_init.lua` - *start Neovim instances with minimal plugin configuration. Used in `Makefile`*

- `Makefile` - *script for launching **tests**, **linting** and docs generation*

The other files are not important and there will be mentioned in the following sections.

## Tests

<!-- TODO: how tests are run -->

<!-- HACK: local development -->

- Run tests using plenary.nvim

## Docs Generation

<!-- TODO: what is interesting about these two generation methods? -->

- Generate Docs from the `README.md` using ...
- Generate Docs from code annotations using ...

## Linting and Formatting

<!-- TODO: explain linting and formatting differences -->

<!-- HACK: local development -->

- Linting using Luacheck ...
- Formatting using Style ...

## Deployment

<!-- TODO: explain tags and releases -->

<!-- HACK: need to setup Luarocks API key -->

- Github release on tag ...
- LuaRocks release on tag ...
