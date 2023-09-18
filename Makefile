DEPENDENCES:=luvit/json luvit/path
OUTPUT:=cssc-ls
SOURCE:=./CSSClasses/
META_FILES:=\
"https://raw.githubusercontent.com/neovim/neovim/master/runtime/lua/vim/lsp/_meta/protocol.lua" \
"https://raw.githubusercontent.com/folke/neodev.nvim/main/types/nightly/uv.lua"

run:
	luvi $(SOURCE)
deps:
	lit install $(DEPENDENCES)
meta:
	# gets meta files for lua-ls
	$(foreach url, $(META_FILES), $(shell curl --create-dirs --output-dir ./meta -O -J $(url)))
build:
	luvi $(SOURCE) -o $(NAME)

#TODO: repl testng(luvit has it)
