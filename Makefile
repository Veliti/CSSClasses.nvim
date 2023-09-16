DEPENDENCES=luvit/json luvit/path
OUTPUT="cssc-ls"
SOURCE=./CSSClasses/

run:
	luvi $(SOURCE)
deps:
	$(SOURCE) lit install $(DEPENDENCES)
build:
	luvi $(PATH) -o $(NAME)
