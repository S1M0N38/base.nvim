.PHONY: test test-one lint format typecheck check dev

test:
	nvim -l tests/minit.lua --minitest $(FILE)

test-one:
	nvim -l tests/minit.lua --minitest tests/$(MODULE)_spec.lua

lint:
	stylua --check lua/ tests/

format:
	stylua lua/ tests/

NVIM_VIMRUNTIME := $(shell nvim --headless -c 'lua io.write(vim.env.VIMRUNTIME)' -c 'q' 2>&1)
typecheck:
	VIM="$(NVIM_VIMRUNTIME)/.." lua-language-server --check_format=pretty --check lua/ --checklevel=Warning --configpath="$$(pwd)/.luarc.json"

check: lint typecheck test

dev:
	nvim -u repro/repro.lua
