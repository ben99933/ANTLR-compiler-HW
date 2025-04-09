all:
	make build

build:
	cd ./src && java -jar ../lib/antlr-4.13.1-complete.jar ./myparser.g4
	cd ./src && javac -Xlint:deprecation -cp ../lib/antlr-4.13.1-complete.jar ./*.java
clean:
	# 除了myparser.g4和myparser.java以外的所有myparser.*文件
	cd ./src && rm -rf ./*.class
	cd ./src && rm -rf ./myparser*.tokens
	cd ./src && rm -rf ./myparserLexer.*
	cd ./src && rm -rf ./myparserBaseListener.*
	cd ./src && rm -rf ./myparserListener.*
	cd ./src && rm -rf ./myparser.interp ./myparserParser.java

test1:
	make clean
	make build
	cd ./src && java -cp ../lib/antlr-4.13.1-complete.jar:. testParser "../test/test1.c"

test2:
	make clean
	make build
	cd ./src && java -cp ../lib/antlr-4.13.1-complete.jar:. testParser "../test/test2.c"

test3:
	make clean
	make build
	cd ./src && java -cp ../lib/antlr-4.13.1-complete.jar:. testParser "../test/test3.c"