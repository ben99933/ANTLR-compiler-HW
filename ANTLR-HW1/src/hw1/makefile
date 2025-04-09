all:
	java -jar ../../lib/antlr-4.13.1-complete.jar ./mylexer.g4
	javac -cp ../../lib/antlr-4.13.1-complete.jar ./*.java

test1:
	make clean
	make
	java -cp ../../lib/antlr-4.13.1-complete.jar:. testLexer "./test/test1.c"

test2:
	make clean
	make
	java -cp ../../lib/antlr-4.13.1-complete.jar:. testLexer "./test/test2.c"

test3:
	make clean
	make
	java -cp ../../lib/antlr-4.13.1-complete.jar:. testLexer "./test/test3.c"

clean:
	rm -rf ./mylexer.java ./mylexer.tokens ./mylexer.interp ./*.class