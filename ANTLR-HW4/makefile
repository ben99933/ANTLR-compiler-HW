all:
	make clean
	make build
	make test1;make test2;make test3;make test4;make testfinal

build:
	cd ./src && java -jar ../lib/antlr-4.13.1-complete.jar ./myCompiler.g4
	cd ./src && javac -Xlint:deprecation -cp ../lib/antlr-4.13.1-complete.jar ./*.java

test1:
	#make clean
	#make build
	cd ./src && java -cp ../lib/antlr-4.13.1-complete.jar:. myCompilerTest "../test/test1.c" > ../test/test1.ll
	@echo "=================test1==========================="
	cd ./test && lli test1.ll
	@echo "=============test1 answer========================"
	cd ./test && gcc test1.c -o test1_answer.exe && ./test1_answer.exe
	@echo "================================================="

test2:
	#make clean
	#make build
	cd ./src && java -cp ../lib/antlr-4.13.1-complete.jar:. myCompilerTest "../test/test2.c" > ../test/test2.ll
	@echo "=================test2==========================="
	cd ./test && lli test2.ll
	@echo "=============test2 answer========================"
	cd ./test && gcc test2.c -o test2_answer.exe && ./test2_answer.exe
	@echo "================================================="

test3:
	#make clean
	#make build
	cd ./src && java -cp ../lib/antlr-4.13.1-complete.jar:. myCompilerTest "../test/test3.c" > ../test/test3.ll
	@echo "=================test3==========================="
	cd ./test && lli test3.ll
	@echo "=============test3 answer========================"
	cd ./test && gcc test3.c -o test3_answer.exe && ./test3_answer.exe
	@echo "================================================="

test4:
	#make clean
	#make build
	cd ./src && java -cp ../lib/antlr-4.13.1-complete.jar:. myCompilerTest "../test/test4.c" > ../test/test4.ll
	@echo "=================test4==========================="
	cd ./test && lli test4.ll
	@echo "=============test4 answer========================"
	cd ./test && gcc test4.c -o test4_answer.exe && ./test4_answer.exe
	@echo "================================================="

testfinal:
	#make clean
	#make build
	cd ./src && java -cp ../lib/antlr-4.13.1-complete.jar:. myCompilerTest "../test/test_case.c" > ../test/test_case.ll
	@echo "=================test_case======================"
	cd ./test && lli test_case.ll
	@echo "==============test_case answer=================="
	cd ./test && gcc test_case.c -o test_case_answer.exe && ./test_case_answer.exe
	@echo "================================================="

clean:
	cd ./src && rm -f ./*.class ./*.tokens ./*.interp
	cd ./src && rm -f ./myCompilerBaseListener.java ./myCompilerLexer.java ./myCompilerListener.java ./myCompilerParser.java
	cd ./test && rm -f ./*.ll ./*.s ./*.exe