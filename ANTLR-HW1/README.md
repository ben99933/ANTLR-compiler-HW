# ANTLR4 Demo for C subset

This is a simple demo of using ANTLR to parse a simple C subset. 
The grammar is defined in `./src/mylexer.g4` and the parser is generated using ANTLR4.

## Build and Run
First of all, the Demo is run in Linux.\
If you are using Windows, you can use WSL or Cygwin to run the Demo.

### Build
To build the project, run the following command:
```bash
make
```

### Run
<!--此專案以makefile執行一些test case為主-->
This project is mainly to run some test cases with makefile.\
To run the test cases, run the following command:
```bash
make test
```

