
TESTS_DIR=tests/
PLUGIN_DIR=lua/plugin_name

DOC_GEN_SCRIPT=./scripts/docs.lua
MINIMAL_INIT=scripts/minimal_init.vim

test:
	nvim --headless --noplugin -u ${MINIMAL_INIT} -c "PlenaryBustedDirectory ${TESTS_DIR} { minimal_init = '${MINIMAL_INIT}' }"

lint:
	luacheck ${PLUGIN_DIR}

docs:
	nvim --headless --noplugin -u ${MINIMAL_INIT} -c "luafile ${DOC_GEN_SCRIPT}" -c 'qa'
