---
name: nvim-test
description: >
  Execute tests and diagnose failures for this Neovim plugin. Use when the user says
  "run tests", "run the suite", or asks to execute the test suite (full, single file,
  or offline). Also use when the user pastes test error output, asks what a test
  failure means, or needs help fixing a broken test. The test stack is mini.test +
  luassert with _spec.lua files. Do not trigger for writing tests, learning test APIs,
  setting up testing from scratch, or non-Neovim tools.
---

# Running Neovim Plugin Tests

This skill covers **running** tests and **diagnosing failures**. For how to
*write* tests, see the `nvim-plugin` skill's `references/TESTS.md`.

## Discover the project's test runner

Before running tests, check how the project invokes the test suite. Look for:

1. `scripts/test` — a shell script (e.g., `nvim -l tests/minit.lua --minitest "$@"`)
2. `Makefile` — a `test` target (e.g., `nvim -l tests/minit.lua --minitest $(FILE)`)
3. If neither exists, run directly: `nvim -l tests/minit.lua --minitest`

## Running tests

### Full test suite

```bash
# Via Makefile (preferred if available)
make test

# Via scripts
./scripts/test

# Direct
nvim -l tests/minit.lua --minitest
```

### Single test file

```bash
# Via Makefile (if available)
make test-one MODULE=base

# Direct — pass the file path
nvim -l tests/minit.lua --minitest tests/base_spec.lua
```

### Running offline (no network)

Set `LAZY_OFFLINE=1` to skip plugin updates. Useful when dependencies are already installed:

```bash
LAZY_OFFLINE=1 nvim -l tests/minit.lua --minitest
```

### With verbose output

```bash
nvim -l tests/minit.lua --minitest -v tests/base_spec.lua
```

## Reading test output

mini.test reports in headless mode:

- **Green `o`** = passed test case
- **Red `x`** = failed test case (with error details below)
- Summary line shows total cases and groups
- Failures are listed at the end with file, line, and error message

### Example output

```
test_base_spec.lua
  describe "setup"
    ✓ it "creates side effects"
    ✓ it "validates config"
  describe "hello"
    ✗ it "returns greeting"
      tests/base_spec.lua:42: Expected:
      "Hello World"
      Got:
      "Hello John Doe"
      stack traceback:
        tests/base_spec.lua:42: in function <tests/base_spec.lua:41>
```

### Diagnosing failures

1. **Read the error message** — luassert shows expected vs actual values
2. **Check the line number** — it points to the assertion that failed
3. **Check the stack trace** — it shows the call chain leading to the failure
4. **Reproduce in isolation** — run just the failing file with `--minitest`
5. **Check for state leaks** — if a test passes alone but fails with the suite,
   something in a previous test didn't clean up (missing `after_each`)

### Common failure patterns

| Error | Cause | Fix |
|-------|-------|-----|
| `Expected: X, Got: Y` | Wrong return value | Check the function logic |
| `attempt to index nil value` | Module not loaded or config not set | Call `setup()` in `before_each` |
| `Vim:E516: buffer is already loaded` | Buffer cleanup missing | Add `after_each` with `pcall(vim.api.nvim_buf_delete, ...)` |
| `test passes alone, fails in suite` | State leak between tests | Check `after_each` cleanup, restore stubs |
| `PENDING: ...` | Conditional test skipped | Install missing dependency or ignore |
| `module 'luassert' not found` | Dependencies not installed | Run without `LAZY_OFFLINE=1` once |

## Existing project files to reference

Before running tests, check if the project already has:

- **`tests/minit.lua`** — the test harness bootstrap. Do not recreate this file.
- **`scripts/test`** — the shell script that invokes the test runner. Use it.
- **`Makefile`** — may have `test`, `test-one`, `check` targets.
- **Existing `*_spec.lua` files** — read them to understand the test structure.

## Test environment details

- **Headless Neovim** — `nvim -l` runs in headless mode. No terminal, no real UI.
- **`--minitest` flag triggers discovery** — mini.test finds `tests/**/*_spec.lua` files automatically.
- **Package path includes `tests/`** — lazy.minit adds `tests/?.lua` to `package.path`.
- **luassert is auto-loaded** — via hererocks, configured by lazy.minit.
