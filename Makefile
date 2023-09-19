OUTPUT:=cssc-ls
SOURCE:=./CSSClasses/
TESTS:=$(shell echo $(SOURCE)tests/* | sed 's|$(SOURCE)||g')
DEPS_LIT:=luvit/json luvit/path luvit/tap
DEPS_ROCK:=debugger
META:=\
"https://raw.githubusercontent.com/neovim/neovim/master/runtime/lua/vim/lsp/_meta/protocol.lua" \
"https://raw.githubusercontent.com/folke/neodev.nvim/main/types/nightly/uv.lua" \

run:
	luvi $(SOURCE)
deps:
	lit install $(DEPS_LIT)
dev_deps:
	luarocks --local --lua-version 5.1 install $(DEPS_ROCK)
	$(foreach url, $(META), $(shell curl --create-dirs --output-dir ./deps -O -J $(url)))
test:
	$(foreach test, $(TESTS), luvi $(SOURCE) -m $(test))
build:
	luvi $(SOURCE) -o $(NAME)

#TODO: repl testng(luvit has it)
