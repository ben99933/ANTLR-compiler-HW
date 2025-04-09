使用環境: WSL , Ubuntu 20.04
使用lib: ANTLR v4.13.1

-----------------編譯 LLVM compiler----------------------
make : 預設執行 make build 與測試所有的test case
(但是terminal 有得時候會錯版 最好一個一個測)

make build : 編譯./src/myCompiler.g4, ./src/myCompilerTest.java

-----------------執行LLVM compiler-----------------------
make test1 : 使用./src/myCompilerTest.java測試./test/test1.c
make test2 : 使用./src/myCompilerTest.java測試./test/test2.c
make test3 : 使用./src/myCompilerTest.java測試./test/test3.c
make test4 : 使用./src/myCompilerTest.java測試./test/test4.c
make testfinal : 使用./src/myCompilerTest.java測試./test/test_case.c

-----------------專案結構----------------------
lib : ANTLR4的jar檔
src : 放置LLVM compiler的程式碼
test : 放置測試的C程式碼

.
├── lib
│   └── antlr-4.13.1-complete.jar : ANTLR4的jar檔
├── C subset description 410410020.docx
├── makefile : 編譯LLVM compiler與檢測test case的makefile
├── readme.txt : 本文件
├── src
│   ├── myCompiler.g4 : ANTLR4的grammar檔
│   └── myCompilerTest.java : 用來測試testcase的程式碼
└── test
    ├── test1.c : int運算 + printf int + printf 多個int
    ├── test2.c : nest if + printf int
    ├── test3.c : for loop + printf int
    ├── test4.c : while loop + printf int
    └── test_case.c : ecourse2上面給的

為了檢查產生出來的 .ll 檔案是否正確
我們將lli 執行出來的結果和使用gcc將.c檔案編譯後執行的結果做比對
因此我在test case中有加入#include<stdio.h>
不過因為處理函數庫並非主要目標 所以我的parser 遇到macro時會直接忽略

makefile有額外使用gcc去編譯.c 方便比對我們LLVM IR編譯器的執行結果

-----------------C subset與編譯器之特色----------------------

作業要求的:
1. 支援int
2. 支援Statements for arithmetic computation
3. Comparison expression. (e.g., a > b)，comparison operation: >、>=、<、<=、==、!=
4. if-then / if-then-else program constructs
5. printf() function with one/two parameters. (support types: %d)

額外的:
1. 支援nested if
2. 支援for loop
3. 支援while loop
4. Statements for arithmetic computation 可用負數
6. 支援printf 多個%d (test1 printf 5個%d)
7. 支援宣告的時候可以直接賦值 (但不適用於for loop和while)
8. 產生有排版的可讀性更高的.ll file
    例如:
    define i32 @main() {
    L1:
        %0 = alloca i32
        store i32 0, i32* %0
        %1 = load i32, i32* %0
        %2 = icmp slt i32 %1, 10
        br i1 %2, label %L2, label %L3
    L2:
        %3 = load i32, i32* %0
        %4 = add i32 %3, 1
        store i32 %4, i32* %0
        br label %L1
    L3:
    }



