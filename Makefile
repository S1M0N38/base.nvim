.PHONY: test test-one lint format typecheck check dev clean

test:
	nvim -l tests/minit.lua --minitest $(FILE)

test-one:
	nvim -l tests/minit.lua --minitest tests/$(MODULE)_spec.lua

lint:
	stylua --check lua/ tests/

format:
	stylua lua/ tests/

typecheck:
	@export TMPFILE="/tmp/base_vimruntime" && \
		nvim --headless -c 'lua io.open(os.getenv("TMPFILE"),"w"):write(vim.env.VIMRUNTIME or ""):close()' -c 'q' 2>/dev/null && \
		VIMRUNTIME="$$(cat "$$TMPFILE")" && rm -f "$$TMPFILE" && \
		test -n "$$VIMRUNTIME" && \
		export VIMRUNTIME && \
		lua-language-server --check_format=pretty --check lua/ --configpath="$$(pwd)/.luarc.json" --checklevel=Warning

check: lint typecheck test

dev:
	nvim -u repro/repro.lua

clean:
	find . -type d -name '.repro' -exec rm -rf {} +
	find . -type d -name '.tests' -exec rm -rf {} +
