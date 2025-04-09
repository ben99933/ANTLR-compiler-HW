all:
	make build

build:
	cd ./src && java -jar ../lib/antlr-4.13.1-complete.jar ./myChecker.g4
	cd ./src && javac -Xlint:deprecation -cp ../lib/antlr-4.13.1-complete.jar ./*.java
clean:
	# 除了myparser.g4和myparser.java以外的所有myparser.*文件
	cd ./src && rm -rf ./*.class
	cd ./src && rm -rf ./*.tokens
	cd ./src && rm -rf ./*.interp
	cd ./src && rm -rf ./myCheckerBaseListener.java ./myCheckerLexer.java ./myCheckerListener.java ./myCheckerParser.java


test1:
	make clean
	make build
	cd ./src && java -cp ../lib/antlr-4.13.1-complete.jar:. myChecker_test "../test/test1.c"

test2:
	make clean
	make build
	cd ./src && java -cp ../lib/antlr-4.13.1-complete.jar:. myChecker_test "../test/test2.c"

test3:
	make clean
	make build
	cd ./src && java -cp ../lib/antlr-4.13.1-complete.jar:. myChecker_test "../test/test3.c"