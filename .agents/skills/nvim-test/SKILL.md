---
name: nvim-test
description: >
  Use this skill when the user wants to write, run, debug, or fix tests in a Neovim Lua plugin project. Triggers on any testing intent — writing new test files, running the test suite (make test, scripts/test, nvim -l), diagnosing failures, adding assertions, or setting up test infrastructure — when working with Lua/Nvim plugin code. The testing stack is mini.test + luassert with busted-style describe/it blocks and _spec.lua file conventions. Do not use for non-Neovim testing (pytest, jest, vitest), formatting, linting, CI setup, benchmarks, or general Lua development without a testing goal.
---

# Neovim Plugin Testing with lazy.minit

This skill covers the testing stack used by modern Neovim plugins (sidekick.nvim, lazy.nvim, etc.):
- **mini.test** — test runner with busted-style `describe`/`it` emulation
- **luassert** — rich assertion library (loaded via hererocks)
- **lazy.minit** — orchestrates everything: bootstraps lazy.nvim, installs mini.test + luassert, discovers and runs `*_spec.lua` files

## Running tests

### Discover the project's test runner

Before running tests, check how the project invokes the test suite. Look for:

1. `scripts/test` — a shell script (e.g. `nvim -l tests/minit.lua --minitest "$@"`)
2. `Makefile` — a `test` target (e.g. `nvim -l tests/minit.lua --minitest $(FILE)`)
3. If neither exists, run directly: `nvim -l tests/minit.lua --minitest`

Run a single test file by passing its path:
```bash
nvim -l tests/minit.lua --minitest tests/util_spec.lua
```

### Running offline (no network)

Set `LAZY_OFFLINE=1` to skip plugin updates. Useful when dependencies are already installed:
```bash
LAZY_OFFLINE=1 nvim -l tests/minit.lua --minitest
```

### Reading test output

mini.test reports in headless mode:
- **Green `o`** = passed test case
- **Red `x`** = failed test case (with error details below)
- Summary line shows total cases and groups
- Failures are listed at the end with file, line, and error message

## Test file structure

### File naming and location

Test files go in `tests/` and must end in `_spec.lua` (this is how mini.test discovers them).

### File header

Every test file must start with the luassert module annotation:
```lua
---@module 'luassert'
```

This gives you type annotations for the full luassert API.

### Busted-style structure

mini.test emulates the busted testing framework. Use `describe` for grouping and `it` for individual test cases:

```lua
---@module 'luassert'

local MyModule = require("myplugin.module")

describe("module name", function()
  before_each(function()
    -- setup runs before each it()
  end)

  after_each(function()
    -- cleanup runs after each it()
  end)

  it("does something specific", function()
    assert.are.equal(expected, actual)
  end)
end)
```

### Nested describe blocks

`describe` blocks can be nested for hierarchical organization. `before_each`/`after_each` cascade from outer to inner blocks:

```lua
describe("parser", function()
  before_each(function()
    -- runs before every it() at any nesting level
  end)

  describe("lua files", function()
    it("parses functions", function()
      -- before_each from parent runs here too
    end)
  end)

  describe("python files", function()
    it("parses classes", function()
      -- before_each from parent runs here too
    end)
  end)
end)
```

## Assertions (luassert)

The most commonly used assertions, in order of frequency:

### Equality

```lua
-- Deep comparison (tables, lists, strings)
assert.are.same({ a = 1 }, { a = 1 })

-- Reference/value equality
assert.are.equal("hello", some_string)
assert.equal(42, some_number)     -- .are is optional for equal
```

### Boolean / nil checks

```lua
assert.is_true(expr)              -- assert.are.equal(true, expr)
assert.is_false(expr)
assert.is_nil(result)
assert.is_not_nil(result)         -- truthy and not nil
```

### Negation modifier

Chain `is_not` (or `not`) to invert any assertion:
```lua
assert.is_not_nil(result)
assert.are_not.same(t1, t2)
```

### Error checking

```lua
-- Assert function does NOT throw
assert.has_no.errors(function()
  health.check()
end)

-- Assert function DOES throw
assert.has_error(function()
  error("boom")
end)

-- Assert error matches pattern
assert.has_error(function()
  error("invalid input")
end, "invalid")
```

### String matching

```lua
assert.matches("pattern", actual_string)
```

### Truthy / Falsy

```lua
assert.is_truthy(val)   -- not false and not nil
assert.is_falsy(val)    -- false or nil
```

### When you need more

The full luassert API includes: `assert.unique`, `assert.near`, `assert.error_matches`, `assert.returned_arguments`, plus spies/stubs/mocks via `require("luassert.spy")` and `require("luassert.stub")`. See the luassert source at `https://github.com/Olivine-Labs/luassert` for details.

## Test recipes

### Table-driven tests

The dominant pattern in the sidekick.nvim test suite. Define test cases as a table, loop over them:

```lua
describe("split_words", function()
  local cases = {
    { "abcd",       { "abcd" } },
    { "abcd.",      { "abcd", "." } },
    { "abc 123",    { "abc", " ", "123" } },
    { "café",       { "café" } },
  }

  for _, case in ipairs(cases) do
    it(case[1] .. " => " .. vim.inspect(case[2]), function()
      assert.are.same(case[2], MyModule.split_words(case[1]))
    end)
  end
end)
```

For more complex cases where the expected behavior varies, use named entries with a `check` function:

```lua
local cases = {
  {
    name = "inline word change",
    input = "foo",
    expected = "bar",
  },
  {
    name = "handles empty string",
    input = "",
    expected = "",
  },
}

for _, case in ipairs(cases) do
  it(case.name, function()
    assert.are.same(case.expected, MyModule.process(case.input))
  end)
end
```

### Stubbing and restoring functions

Save the original in `before_each`, override it, restore in `after_each`:

```lua
describe("my function", function()
  local original_notify

  before_each(function()
    original_notify = vim.notify
  end)

  after_each(function()
    vim.notify = original_notify
  end)

  it("calls vim.notify with error level", function()
    local calls = {}
    vim.notify = function(msg, level, opts)
      table.insert(calls, { msg = msg, level = level, opts = opts })
    end

    MyModule.error("oops")

    assert.are.same({
      { msg = "oops", level = vim.log.levels.ERROR, opts = { title = "MyPlugin" } },
    }, calls)
  end)
end)
```

For stubbing module functions:

```lua
local Config = require("myplugin.config")

before_each(function()
  original = Config.get_client
  Config.get_client = function()
    return { id = 42 }
  end
end)

after_each(function()
  Config.get_client = original
end)
```

### Creating test buffers

Use scratch buffers to test buffer-level logic:

```lua
describe("buffer operations", function()
  local buf, win

  before_each(function()
    buf = vim.api.nvim_create_buf(false, true)  -- unlisted, scratch
    win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
  end)

  after_each(function()
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end)

  it("detects function at cursor", function()
    vim.bo[buf].filetype = "lua"
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
      "local function test()",
      "  return 42",
      "end",
    })
    vim.api.nvim_win_set_cursor(win, { 2, 2 })

    local result = MyModule.get_function_at_cursor()
    assert.is_not_nil(result)
  end)
end)
```

### Conditional tests (Treesitter, external tools)

Some tests depend on parsers or external tools being available. Skip gracefully:

```lua
local function pending(msg)
  print("PENDING: " .. msg)
  assert.is_true(true)
end

local function has_parser(lang)
  local ok, _ = pcall(vim.treesitter.get_parser, nil, lang)
  return ok
end

it("parses python functions", function()
  if not has_parser("python") then
    pending("Python parser not available")
    return
  end
  -- ... actual test
end)
```

### Testing with file buffers

Some functionality requires real file buffers (not scratch buffers). Use temp files:

```lua
it("reads file content", function()
  local tmp = vim.fn.tempname() .. ".lua"
  vim.fn.writefile({ "local foo = 1" }, tmp)
  local file_buf = vim.fn.bufadd(tmp)
  vim.fn.bufload(file_buf)
  vim.bo[file_buf].buflisted = true
  vim.api.nvim_win_set_buf(win, file_buf)

  -- ... test logic

  vim.fn.delete(tmp)
  vim.api.nvim_buf_delete(file_buf, { force = true })
end)
```

### Complex stub with call capture

For testing interactions with multiple subsystems:

```lua
local function stub_module(module_path, method)
  local mod = require(module_path)
  local original = mod[method]
  local calls = {}

  mod[method] = function(...)
    table.insert(calls, { args = { ... } })
    return original(...)  -- or return a mock value
  end

  return calls, function()
    mod[method] = original
  end
end

-- Usage:
it("tracks calls to highlight", function()
  local calls, restore = stub_module("myplugin.highlight", "apply")
  MyModule.do_something()
  restore()
  assert.are.equal(1, #calls)
end)
```

### Saving and restoring config

Test different configurations without cross-test contamination:

```lua
describe("config behavior", function()
  local original_config

  before_each(function()
    original_config = vim.deepcopy(require("myplugin.config"))
  end)

  after_each(function()
    local Config = require("myplugin.config")
    for k, v in pairs(original_config) do
      Config[k] = v
    end
  end)

  it("uses default value", function()
    require("myplugin").setup({})
    assert.are.equal("default", require("myplugin.config").some_option)
  end)

  it("uses custom value", function()
    require("myplugin").setup({ some_option = "custom" })
    assert.are.equal("custom", require("myplugin.config").some_option)
  end)
end)
```

## Existing project files to reference

Before writing test infrastructure from scratch, check if the project already has:

- **`tests/minit.lua`** — the test harness bootstrap. Reads it to understand what dependencies are loaded (Treesitter parsers, extra plugins, etc.). Do not recreate this file unless it doesn't exist.
- **`scripts/test`** — the shell script that invokes the test runner. Use it to run tests.
- **`Makefile`** — may have `test`, `test-one`, `check` targets.
- **`tests/fixtures/`** — shared test data. Check what's already available before creating new fixtures.
- **Existing `*_spec.lua` files** — read them to match the project's testing style and conventions.

When creating a new test file, look at an existing `_spec.lua` in the project first and follow the same patterns.

## Key things to remember

1. **Always clean up** — delete buffers, restore overridden functions, reset config in `after_each`. Tests run in the same Neovim process, so state leaks between tests.

2. **The test environment is headless Neovim** — `nvim -l` runs in headless mode. No terminal, no real UI. Use `vim.api` calls instead of simulating user input when possible.

3. **`--minitest` flag triggers discovery** — mini.test finds `tests/**/*_spec.lua` files automatically.

4. **luassert is the assertion layer** — it's loaded via hererocks (configured by lazy.minit). The `---@module 'luassert'` annotation gives you completions.

5. **Package path includes `tests/`** — lazy.minit adds `tests/?.lua` to `package.path`, so you can `require("fixtures.helpers")` from `tests/fixtures/helpers.lua`.
