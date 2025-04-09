使用環境: WSL , Ubuntu 20.04

-----------------編譯Parser-----------------------
make : 預設執行 make build
make build : 編譯./src/MyParser.g4, ./src/testParser.java

-----------------執行Parser-----------------------
make test1 : 使用./src/testParser.java測試./test/test1.c
make test2 : 使用./src/testParser.java測試./test/test2.c
make test3 : 使用./src/testParser.java測試./test/test3.c


-----------------專案結構----------------------
lib : ANTLR4的jar檔
src : 放置Parser的程式碼
test : 放置測試的C程式碼
