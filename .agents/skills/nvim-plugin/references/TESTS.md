# Neovim Plugin Testing Recipes

A catalog of testing patterns for Neovim Lua plugins using **mini.test** +
**luassert** with busted-style `describe`/`it` blocks.

> For running tests and analyzing output, use the `nvim-test` skill.

---

## Table of Contents

1. [Test File Structure](#1-test-file-structure)
2. [Assertions Quick Reference](#2-assertions-quick-reference)
3. [Table-Driven Tests](#3-table-driven-tests)
4. [Stubbing and Restoring](#4-stubbing-and-restoring)
5. [Creating Test Buffers](#5-creating-test-buffers)
6. [Testing with File Buffers](#6-testing-with-file-buffers)
7. [Testing Config Changes](#7-testing-config-changes)
8. [Conditional Tests](#8-conditional-tests)
9. [Testing Notifications](#9-testing-notifications)
10. [Testing Highlights](#10-testing-highlights)
11. [Testing Autocmds](#11-testing-autocmds)
12. [Testing Keymaps](#12-testing-keymaps)
13. [Test Anti-Patterns](#13-test-anti-patterns)
14. [Advanced Testing Patterns](#14-advanced-testing-patterns)

---

## 1. Test File Structure

### File naming and location

Test files go in `tests/` and must end in `_spec.lua` (this is how mini.test
discovers them).

### File header

Every test file starts with the luassert module annotation:

```lua
---@module 'luassert'
```

### Basic structure

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

  finally(function()
    -- one-time cleanup after ALL tests in this describe block
    -- runs regardless of pass/fail
  end)

  it("does something specific", function()
    assert.are.equal(expected, actual)
  end)
end)
```

### Nested describe blocks

`before_each`/`after_each` cascade from outer to inner blocks:

```lua
describe("parser", function()
  before_each(function()
    -- runs before every it() at any nesting level
  end)

  describe("lua files", function()
    it("parses functions", function() end)
  end)

  describe("python files", function()
    it("parses classes", function() end)
  end)
end)
```

---

## 2. Assertions Quick Reference

The most commonly used luassert assertions:

### Equality

```lua
-- Deep comparison (tables, lists, strings)
assert.are.same({ a = 1 }, { a = 1 })

-- Reference/value equality
assert.are.equal("hello", some_string)
assert.equal(42, some_number)       -- .are is optional for equal
```

### Boolean / nil checks

```lua
assert.is_true(expr)
assert.is_false(expr)
assert.is_nil(result)
assert.is_not_nil(result)
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

### Full API

luassert also includes: `assert.unique`, `assert.near`,
`assert.error_matches`, `assert.returned_arguments`, plus spies/stubs/mocks
via `require("luassert.spy")` and `require("luassert.stub")`.

---

## 3. Table-Driven Tests

The dominant pattern in production Neovim plugin test suites. Define test cases
as a table, loop over them.

### Simple cases — input/output pairs

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

### Named cases with check function

For more complex cases where the expected behavior varies:

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

### Cases with custom check function

```lua
local cases = {
  {
    name = "detects change",
    check = function(diff)
      assert.is_true(diff.has_changes)
      assert.are.equal("change", diff.hunks[1].kind)
    end,
  },
}

for _, case in ipairs(cases) do
  it(case.name, function()
    local diff = MyModule.diff(case.input)
    case.check(diff)
  end)
end
```

---

## 4. Stubbing and Restoring

### Basic stub/restore pattern

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

### Stubbing module functions

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

### Reusable stub helper with call capture

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

### luassert stub (formal)

```lua
local stub = require("luassert.stub")

it("stubs vim.notify", function()
  stub(vim, "notify")
  MyModule.warn("test")
  assert.stub(vim.notify).was_called_with("test", vim.log.levels.WARN, match.is_table())
  vim.notify:revert()  -- restore
end)
```

---

## 5. Creating Test Buffers

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

---

## 6. Testing with File Buffers

Some functionality requires real file buffers (not scratch buffers):

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

---

## 7. Testing Config Changes

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

---

## 8. Conditional Tests

Some tests depend on parsers or external tools. Skip gracefully:

> **Note**: mini.test does not have a built-in `pending()` or `skip()` function.
> The pattern below is a custom workaround — the test will show as PASSED, not SKIPPED.

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

---

## 9. Testing Notifications

Capture and assert notification calls:

```lua
describe("notifications", function()
  local notify_calls, original_notify

  before_each(function()
    original_notify = vim.notify
    notify_calls = {}
    vim.notify = function(msg, level, opts)
      table.insert(notify_calls, {
        msg = msg,
        level = level,
        title = opts and opts.title,
      })
    end
  end)

  after_each(function()
    vim.notify = original_notify
  end)

  it("sends error notification with title", function()
    MyModule.error("something failed")
    assert.are.equal(1, #notify_calls)
    assert.are.equal("something failed", notify_calls[1].msg)
    assert.are.equal(vim.log.levels.ERROR, notify_calls[1].level)
    assert.are.equal("MyPlugin", notify_calls[1].title)
  end)
end)
```

---

## 10. Testing Highlights

Verify highlight groups are defined correctly:

```lua
describe("highlights", function()
  it("defines link groups with default = true", function()
    MyModule.set_hl()
    local hl = vim.api.nvim_get_hl(0, { name = "MyPluginTitle", link = false })
    assert.is_not_nil(hl.link)
    assert.are.equal("FloatTitle", hl.link)
    -- Check that default was set
    -- (vim.api.nvim_get_hl returns the resolved value, not the definition)
  end)

  it("persists highlights after colorscheme change", function()
    MyModule.set_hl()
    vim.cmd("colorscheme default")
    -- Trigger the ColorScheme autocmd
    -- Check highlight still exists
    local hl = vim.api.nvim_get_hl(0, { name = "MyPluginTitle" })
    assert.is_not_nil(hl)
  end)
end)
```

---

## 11. Testing Autocmds

Verify autocmds fire correctly:

```lua
describe("autocmds", function()
  local fired_events

  before_each(function()
    fired_events = {}
    -- Hook into the plugin's augroup
    vim.api.nvim_create_autocmd("User", {
      pattern = "MyPlugin*",
      callback = function(ev)
        table.insert(fired_events, ev.match)
      end,
    })
  end)

  it("emits custom event on toggle", function()
    MyModule.toggle()
    assert.are.equal(1, #fired_events)
    assert.matches("MyPluginToggled", fired_events[1])
  end)
end)
```

---

## 12. Testing Keymaps

Verify keymaps are set correctly:

```lua
describe("keymaps", function()
  it("creates <Plug> mapping", function()
    MyModule.setup({})
    local maps = vim.api.nvim_get_keymap("n")
    local found = false
    for _, m in ipairs(maps) do
      if m.lhs == "<Plug>(MyPluginAction)" then
        found = true
        assert.is_not_nil(m.callback)
        break
      end
    end
    assert.is_true(found)
  end)

  it("skips empty mappings", function()
    MyModule.setup({ mappings = { action_key = "" } })
    -- Should not error and should not create the mapping
    local maps = vim.api.nvim_get_keymap("n")
    for _, m in ipairs(maps) do
      assert.is_not.equal("<Plug>(MyPluginAction)", m.lhs)
    end
  end)
end)
```

---

## 13. Test Anti-Patterns

### ❌ Don't: Leave state behind between tests

```lua
-- ❌ Buffer leaks into the next test
it("creates a buffer", function()
  local buf = vim.api.nvim_create_buf(false, true)
  -- ... forgot to delete
end)

-- ✅ Always clean up in after_each
after_each(function()
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
end)
```

### ❌ Don't: Mutate global state without restoring

```lua
-- ❌ vim.o is permanently changed
it("sets an option", function()
  vim.o.number = true
end)

-- ✅ Save and restore
local original
before_each(function()
  original = vim.o.number
end)
after_each(function()
  vim.o.number = original
end)
```

### ❌ Don't: Test implementation details

```lua
-- ❌ Brittle — breaks if you rename the internal variable
assert.are.equal("my_value", MyModule._internal_state)

-- ✅ Test observable behavior
assert.are.equal("expected output", MyModule.public_api())
```

### ❌ Don't: Use plenary.nvim for testing

```lua
-- ❌ Unmaintained, limited feature set, no process isolation
-- plenary.test_harness

-- ✅ Use mini.test + luassert (via lazy.minit)
```

> **Note**: plenary.nvim is not formally deprecated but is effectively unmaintained.
> The Neovim community has moved to mini.test for its process isolation and
> active maintenance.

### ❌ Don't: Make tests depend on external services

```lua
-- ❌ Network call in test
it("fetches data", function()
  local data = vim.system({"curl", "https://api.example.com"}):wait()
end)

-- ✅ Stub the network call
it("fetches data", function()
  local calls, restore = stub_module("myplugin.http", "get")
  MyModule.fetch()
  restore()
  assert.are.equal(1, #calls)
end)
```

---

## 14. Advanced Testing Patterns

### Error capture helper

Capture error messages without mocking the entire notification system:

```lua
local function capture_errors(mod, method)
  local errors = {}
  local original = mod[method]
  mod[method] = function(msg)
    table.insert(errors, msg)
  end
  return errors, function()
    mod[method] = original
  end
end

-- Usage:
it("rejects invalid input", function()
  local errs, restore = capture_errors(Util, "error")
  MyModule.process("bad input")
  restore()
  assert.are.equal(1, #errs)
  assert.matches("invalid", errs[1])
end)
```

### Combinatorial testing (all parameter combinations)

```lua
for _, use_treesitter in ipairs({ true, false }) do
  for _, use_indent in ipairs({ true, false }) do
    it(("works with ts=%s indent=%s"):format(use_treesitter, use_indent), function()
      MyModule.setup({ treesitter = use_treesitter, indent = use_indent })
      assert.is_not_nil(MyModule.process())
    end)
  end
end
```

### Reference implementation testing

Test an optimized implementation against a simple reference:

```lua
-- Simple reference (obviously correct, maybe slow)
local function reference_match(pattern, items)
  local chars = vim.split(pattern, "")
  local pat = table.concat(chars, ".*")
  return vim.tbl_filter(function(v) return v:find(pat) end, items)
end

-- Test optimized matcher matches reference
for _, pattern in ipairs({ "abc", "foo", "x" }) do
  it(("matches reference for '%s'"):format(pattern), function()
    local expected = reference_match(pattern, test_items)
    local actual = OptimizedMatcher.match(pattern, test_items)
    assert.are.same(expected, actual)
  end)
end
```

### Visual mode testing

Test features that depend on visual selection:

```lua
it("gets visual selection", function()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "hello world" })
  vim.api.nvim_win_set_cursor(win, { 1, 0 })
  vim.cmd("normal! v4l")  -- select "hello"
  local sel = MyModule.get_selection()
  vim.cmd("normal! \27")   -- ESC
  assert.are.equal("hello", sel)
end)
```

### Input simulation with `nvim_feedkeys`

For complex key sequences, `nvim_feedkeys` is more reliable than `vim.cmd("normal!")`:

```lua
local function feedkeys(keys)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(keys, true, false, true),
    "x",
    false
  )
end

it("handles multi-key input", function()
  feedkeys("iHello<CR><Esc>")
  assert.are.equal("Hello", vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1])
end)
```

### Waiting for async operations

`vim.schedule` callbacks don't execute during synchronous test execution.
Use `vim.wait` to flush scheduled operations:

```lua
it("waits for scheduled callback", function()
  local done = false
  vim.schedule(function()
    done = true
  end)
  vim.wait(1000, function()
    return done
  end, 50)
  assert.is_true(done)
end)

it("waits for LSP attachment", function()
  -- trigger LSP attach...
  vim.wait(1000, function()
    return #vim.lsp.get_clients() > 0
  end)
  -- now safe to test LSP-dependent features
end)
```

### Buffer-local keymap testing

Use `nvim_buf_get_keymap` to test buffer-local keymaps:

```lua
it("sets buffer-local keymaps in plugin window", function()
  local buf = vim.api.nvim_create_buf(false, true)
  -- ... setup plugin on buf ...
  local maps = vim.api.nvim_buf_get_keymap(buf, "n")
  local found = false
  for _, m in ipairs(maps) do
    if m.lhs == "q" then
      found = true
      assert.are.equal("Close window", m.desc)
      break
    end
  end
  assert.is_true(found)
  vim.api.nvim_buf_delete(buf, { force = true })
end)
```
