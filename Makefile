MINIMAL_INIT=./scripts/minimal_init.vim
TESTS_DIR=tests/
PLUGIN_DIR=lua/plugin_name

test:
	nvim --headless --noplugin -u ${MINIMAL_INIT} -c "PlenaryBustedDirectory ${TESTS_DIR} { minimal_init = '${MINIMAL_INIT}' }"

lint:
	luacheck ${PLUGIN_DIR}

docgen:
	nvim --headless --noplugin -u ${MINIMAL_INIT} -c "luafile ./scripts/gendocs.lua" -c 'qa'
