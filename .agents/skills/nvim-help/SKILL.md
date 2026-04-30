---
name: nvim-help
description: Search and read Neovim's built-in :help documentation to look up API signatures, parameter types, option values, and event specifications from the user's installed runtime. Use when the user wants to consult reference material — function docs, help tags, option descriptions — not when they want to write, create, or debug something. For writing Neovim Lua code, composing Treesitter queries, or fixing config issues, use general coding tools instead. Pairs with Context7 (neovim/neovim) for code examples; this skill provides exact local signatures and docs.
---

# Neovim Help

Neovim's help docs are plain text in `$VIMRUNTIME/doc/`. Resolve the path once per session:

```bash
VIMRUNTIME=$(nvim -l /dev/stdin <<< 'io.write(vim.env.VIMRUNTIME)' 2>/dev/null)
```

Tags are `*like-this*`, cross-references are `|like-this|`, code blocks are between `>` and `<` lines.

## Search tags by keyword

```bash
grep -i '<keyword>' "$VIMRUNTIME/doc/tags"
```

Output: `<tag>\t<help-file>\t<search-pattern>`

When presenting tag search results, show the **full path** to each file (e.g. `$VIMRUNTIME/doc/treesitter.txt`), not just the filename.

## Read a help section for an exact tag

Escape dots (`\.`) and parens (`\(\)`) for sed.

```bash
sed -n '/\*<exact-tag>\*/,/^====/p' "$VIMRUNTIME/doc/<help-file>"
# e.g. sed -n '/\*vim\.keymap\.set()\*/,/^====/p' "$VIMRUNTIME/doc/lua.txt"
# e.g. sed -n '/\*nvim_open_win()\*/,/^====/p' "$VIMRUNTIME/doc/api.txt"
```

## Full-text search across all help files

```bash
grep -rn '<pattern>' "$VIMRUNTIME/doc/"*.txt
```

## Table of contents for a help file

```bash
awk '/^===/{getline; print "  L" NR ": " $0}' "$VIMRUNTIME/doc/<file>"
```

## List all tags in a file

```bash
awk -F'\t' '$2 == "<file>" {print $1}' "$VIMRUNTIME/doc/tags"
```

## List all help files

```bash
ls "$VIMRUNTIME/doc/"*.txt
```

## Output format

Always return the **full raw help text** — not a summary or paraphrase. The user needs exact parameter signatures, types, and descriptions from the installed version.

### Single file

State the file path **above** the code block using inline code, then the raw vimdoc in a fenced block:

From `$VIMRUNTIME/doc/lua.txt`:
```vimdoc
vim.keymap.set({modes}, {lhs}, {rhs}, {opts})               *vim.keymap.set()*
    ...
```

### Multiple files

Use **separate code blocks** for each help file, each with its own file path above:

From `$VIMRUNTIME/doc/api.txt`:
```vimdoc
nvim_open_win({buffer}, {enter}, {config})                   *nvim_open_win()*
    ...
```

From `$VIMRUNTIME/doc/api.txt`:
```vimdoc
nvim_win_set_config({window}, {config})                *nvim_win_set_config()*
    ...
```

### Exploratory searches

When a keyword search returns multiple tags, show the **most relevant** section in full. Then, after the code block, list other relevant tags the user can request next:

From `$VIMRUNTIME/doc/treesitter.txt`:
```vimdoc
TREESITTER LANGUAGE INJECTIONS                *treesitter-language-injections*
    ...
```

Other relevant tags: `treesitter-query`, `treesitter-highlight`

This keeps the response focused while giving the user a path to dig deeper.

### General rules

- Do not put the file path inside the code block — always above it.
- Do not narrate how the text was found (e.g. no "extracted via sed"). Just return the docs.
- If multiple help files are relevant, use separate code blocks per file.

## Context7 (optional)

If the Context7 MCP tool is available, you can also query it for richer Lua code examples and broader explanations using library ID `neovim/neovim`. This complements (but does not replace) the exact parameter signatures from local help docs.
