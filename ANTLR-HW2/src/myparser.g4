grammar myparser;

options {
    language = Java;
}

@members{
    boolean TRACEON = true;
}

//comment
//    :   LINE_COMMENT {if (TRACEON) System.out.println("comment: LINE_COMMENT");}
//    |   BLOCK_COMMENT {if (TRACEON) System.out.println("comment: BLOCK_COMMENT");}
//    ;
//macro
//    :   MACRO {if (TRACEON) System.out.println("macro: MACRO");}
//    ;


program
    :   type MAIN '(' ')' '{' statements '}' {if (TRACEON) System.out.println("program: type MAIN '(' ')' '{' statements '}'");}
    ;

type
    :   UNSIGNED_TYPE   {if (TRACEON) System.out.println("type: UNSIGNED_TYPE");}
    |   SIGNED_TYPE     {if (TRACEON) System.out.println("type: SIGNED_TYPE");}
    |   SHORT_TYPE      {if (TRACEON) System.out.println("type: SHORT_TYPE");}
    |   LONG_TYPE       {if (TRACEON) System.out.println("type: LONG_TYPE");}
    |   BOOL_TYPE       {if (TRACEON) System.out.println("type: BOOL_TYPE");}
    |   CHAR_TYPE       {if (TRACEON) System.out.println("type: CHAR_TYPE");}
    |   INT_TYPE        {if (TRACEON) System.out.println("type: INT_TYPE");}
    |   FLOAT_TYPE      {if (TRACEON) System.out.println("type: FLOAT_TYPE");}
    |   DOUBLE_TYPE     {if (TRACEON) System.out.println("type: DOUBLE_TYPE");}
    |   VOID_TYPE       {if (TRACEON) System.out.println("type: VOID_TYPE");}
//    |   STRUCT_TYPE     {if (TRACEON) System.out.println("type: STRUCT_TYPE");}
//    |   ENUM_TYPE       {if (TRACEON) System.out.println("type: ENUM_TYPE");}
//    |   UNION_TYPE      {if (TRACEON) System.out.println("type: UNION_TYPE");}
    ;

//function
//    :   MAIN '(' ')' '{' statements '}'                 {if (TRACEON) System.out.println("function: MAIN '(' ')' '{' statements '}'");}
//    |   MULTIPLY_OR_POINTER* ID func
//    |   '{' (declaration ';' | expression ';')* '}' ';'    {if (TRACEON) System.out.println("function: '{' (declaration ';' | expression ';')* '}' ';'");}
//    ;
//
////可以用在宣告function和變數的後半部分
//func
//    :   ';'                                     {if (TRACEON) System.out.println("func: ID;");}
//    |   '=' expression ';'                      {if (TRACEON) System.out.println("func: '=' expression ';'");}
//    |   '(' ((declaration | expression) (','(declaration | expression))*)* ')' '{' statements'}'  {if (TRACEON) System.out.println("func: '(' ((declaration | expression) (','(declaration | expression))*)* ')' '{' statements'}'");}
//    ;

declaration
    :   type assignmentStatement {if (TRACEON) System.out.println("declaration: type expression");}
    ;

functionPrintf
    :   PRINTF'(' STRING_VALUE (',' arithmeticExpression)* ')' {if (TRACEON) System.out.println("functionPrintf: PRINTF '(' STRING_VALUE (',' arithmeticExpression)* ')' ");}
    ;
functionReturn
    :   RETURN arithmeticExpression {if (TRACEON) System.out.println("functionReturn: RETURN arithmeticExpression ");}
    ;

arithmeticExpression: condOrExpression {if (TRACEON) System.out.println("arithmeticExpression: condOrExpression");}
    ;
condOrExpression: condAndExpression (COND_OR condAndExpression)* {if (TRACEON) System.out.println("condOrExpression: condAndExpression (COND_OR condAndExpression)*");}
    ;
condAndExpression: relationalExpression ((EQUALS | NOTEQUALS) relationalExpression)* {if (TRACEON) System.out.println("condAndExpression: relationalExpression ((EQUALS | NOTEQUALS) relationalExpression)*");}
    ;
relationalExpression: addExpresion ((LESSTHAN | LESSEQ| GREATERTHAN | GREATEQ) addExpresion)* {if (TRACEON) System.out.println("relationalExpression: addExpresion ((LESSTHAN | LESSEQ | GREATERTHAN | GREATEQ) addExpresion)*");}
    ;
addExpresion: multiplyExpresion ((PLUS | MINUS) multiplyExpresion)* {if (TRACEON) System.out.println("addExpresion: multiplyExpresion ((PLUS | MINUS) multiplyExpresion)*");}
    ;
multiplyExpresion: signPrimaryExpression ((MULTIPLY_OR_POINTER | DIVIDE | MOD) signPrimaryExpression)* {if (TRACEON) System.out.println("multiplyExpresion: signPrimaryExpression ((MULTIPLY_OR_POINTER | DIVIDE | MOD) signPrimaryExpression)*");}
    ;

signPrimaryExpression
    :   primaryExpression {if (TRACEON) System.out.println("signPrimaryExpression: primaryExpression");}
    |   MINUS primaryExpression {if (TRACEON) System.out.println("signPrimaryExpression: MINUS primaryExpression");}
    ;

primaryExpression
    :   INTEGER_VALUE {if (TRACEON) System.out.println("primaryExpression: INTEGER_VALUE");}
    |   FLOATING_VALUE {if (TRACEON) System.out.println("primaryExpression: FLOATING_VALUE");}
    |   ID {if (TRACEON) System.out.println("primaryExpression: ID");}
    |   CHAR_VALUE {if (TRACEON) System.out.println("primaryExpression: CHAR_VALUE");}
    |   STRING_VALUE {if (TRACEON) System.out.println("primaryExpression: STRING_VALUE");}
    |   '(' arithmeticExpression ')' {if (TRACEON) System.out.println("primaryExpression: '(' expression ')'");}
    |   functionPrintf {if (TRACEON) System.out.println("primaryExpression: functionPrintf");}
    |   functionReturn {if (TRACEON) System.out.println("primaryExpression: functionReturn");}
    ;


statements
    :   statement statements {if (TRACEON) System.out.println("statements: statement statements");}
//    |   '{' statements '}' {if (TRACEON) System.out.println("statements: '{' statements '}'");}
    |
    ;
statement
    :   assignmentStatement';' {if (TRACEON) System.out.println("statement: assignmentStatement';'");}
    |   declaration ';' {if (TRACEON) System.out.println("statement: declaration';'");}
    |   ifStatement {if (TRACEON) System.out.println("statement: ifStatement");}
    |   forStatement {if (TRACEON) System.out.println("statement: forStatement");}
    |   whileStatement {if (TRACEON) System.out.println("statement: whileStatement");}
    |   controlStatement {if (TRACEON) System.out.println("statement: controlStatement");}
    ;
assignmentStatement
    :   ID assign arithmeticExpression {if (TRACEON) System.out.println("assignmentStatement: ID ASSIGN arithmeticExpression");}
    |   arithmeticExpression
    |
    ;
blockStatement
    :   statement
    |   '{' statements '}'
    ;

assign
    :   ASSIGN
    |   ASSIGN_INC
    |   ASSIGN_DEC
    |   ASSIGN_MUL
    |   ASSIGN_DIV
    |   ASSIGN_MOD
    |   ASSIGN_AND
    |   ASSIGN_OR
    |   ASSIGN_XOR
    ;







condEqual
    :   EQUALS {if (TRACEON) System.out.println("condEqual: EQUALS");}
    |   NOTEQUALS {if (TRACEON) System.out.println("condEqual: NOTEQUALS");}
    ;


compare
    :   LESSTHAN {if (TRACEON) System.out.println("compareExpression: LESSTHAN");}
    |   GREATERTHAN {if (TRACEON) System.out.println("compareExpression: GREATERTHAN");}
    |   LESSEQ {if (TRACEON) System.out.println("compareExpression: LESSEQ");}
    |   GREATEQ {if (TRACEON) System.out.println("compareExpression: GREATEQ");}
    ;

ifStatement
    :   IF '(' arithmeticExpression ')' blockStatement {if (TRACEON) System.out.println("ifStatement: IF '(' arithmeticExpression ')' blockStatement");}
    |   IF '(' arithmeticExpression ')' blockStatement  ELSE blockStatement  {if (TRACEON) System.out.println("ifStatement: IF '(' arithmeticExpression ')' blockStatement  ELSE blockStatement");}
    ;

forStatement
    :   FOR '(' (declaration|assignmentStatement) ';' arithmeticExpression ';' assignmentStatement ')' blockStatement {if (TRACEON) System.out.println("forStatement: FOR '(' (declaration|assignmentStatement) ';' arithmeticExpression ';' assignmentStatement ')' blockStatement");}
    ;
whileStatement
    :   WHILE '(' arithmeticExpression ')' blockStatement {if (TRACEON) System.out.println("whileStatement: WHILE '(' arithmeticExpression ')' blockStatement");}
    ;
controlStatement
    :   BREAK ';' {if (TRACEON) System.out.println("controlStatement: BREAK ';'");}
    |   CONTINUE ';' {if (TRACEON) System.out.println("controlStatement: CONTINUE ';'");}
    ;



// Keywords
TYPEDEF     : 'typedef';
SIZEOF      : 'sizeof';
EXTERN      : 'extern';

//===========================data type===========================
UNSIGNED_TYPE   : 'unsigned';
SIGNED_TYPE     : 'signed';
SHORT_TYPE      : 'short';
LLONG_TYPE      : 'long long';
LONG_TYPE       : 'long';
BOOL_TYPE       : 'bool';
CHAR_TYPE       : 'char';
INT_TYPE        : 'int';
FLOAT_TYPE      : 'float';
DOUBLE_TYPE     : 'double';
VOID_TYPE       : 'void';

STRUCT_TYPE     : 'struct';
ENUM_TYPE       : 'enum';
UNION_TYPE      : 'union';

//型態修飾詞
CONST       : 'const';
REGISTER    : 'register';
VOLATILE    : 'volatile';
RESTRICT    : 'restrict';
STATIC      : 'static';

//==============================================================

//=======================control flow===========================
RETURN      : 'return';
GOTO        : 'goto';
//if else
IF          : 'if';
ELSE        : 'else';
//loop
FOR         : 'for';
WHILE       : 'while';
DO          : 'do';
BREAK       : 'break';
CONTINUE    : 'continue';
//switch
SWITCH      : 'switch';
CASE        : 'case';
DEFAULT     : 'default';

CONDITIONAL     : IF | ELSE ;
LOOP            : FOR | WHILE | DO;


// Comments
LINE_COMMENT    : '//' ~[\r\n]* -> skip;
BLOCK_COMMENT   : '/*' .*? '*/' -> skip;
//LINE_COMMENT    : '//' ~[\r\n]*;
//BLOCK_COMMENT   : '/*' .*? '*/';



// operator
LOGIC_AND       : '&';
LOGIC_OR        : '|';
RSHIFT          : '>>';
LSHIFT          : '<<';

MOD             : '%';
DIVIDE          : '/';
MULTIPLY_OR_POINTER: '*';
PLUS            : '+';
MINUS           : '-';
BITWISE_NOT     : '~';

NOT             : '!';
COND_AND        : '&&';
COND_OR         : '||';

//assignment
ASSIGN          : '=';
ASSIGN_INC      : '+=';
ASSIGN_DEC      : '-=';
ASSIGN_MUL      : '*=';
ASSIGN_DIV      : '/=';
ASSIGN_MOD      : '%=';
ASSIGN_AND      : '&=';
ASSIGN_OR       : '|=';
ASSIGN_XOR      : '^=';

//comparison
EQUALS          : '==';
LESSEQ          : '<=';
GREATEQ         : '>=';
NOTEQUALS       : '!=';
LESSTHAN        : '<';
GREATERTHAN     : '>';

INCREMENT       : '++';
DECREMENT       : '--';

ARROW           : '->';
MEMBER          : '.';



// Punctuation symbols
COMMA           : ',';
SEMICOLON       : ';';
LPAREN          : '(';
RPAREN          : ')';
LBRACE          : '{';
RBRACE          : '}';
LBRACK          : '[';
RBRACK          : ']';


// Function
MAIN            : 'main';
PRINTF          : 'printf';

// Macro
INCLUDE         : 'include<'  ID '.h>';
DEFINE          : 'define';
IFDEF           : 'ifdef';
IFNDEF          : 'ifndef';
ENDIF           : 'endif';
UNDEF           : 'undef';
MACRO           : '#' (INCLUDE | DEFINE | IFDEF | IFNDEF | ENDIF | UNDEF) -> skip;


// Identifiers and literals
NULL            : 'NULL';
ID              : LETTER (LETTER | DIGIT)*;
INTEGER_VALUE       : '0' | (('1'..'9')DIGIT*);
FLOATING_VALUE     : FLOAT_VALUE1 | FLOAT_VALUE2 | FLOAT_VALUE3;
CHAR_VALUE      : '\'' (ESC | ~['\\]) '\'';
STRING_VALUE    : '"' (ESC | ~["\\])* '"';
WHITE_SPACE   : [ \t\r\n]+ -> skip;
//WHITE_SPACE     : [ \t\r\n]+;


//==================================Fragments==================================

//basic
fragment DIGIT  : '0'..'9';
fragment LETTER : [a-zA-Z_];
fragment ESC    : '\\' .;

// Floating point literals
fragment FLOAT_VALUE1 : DIGIT+ '.' DIGIT*;
fragment FLOAT_VALUE2 : '.' DIGIT+;
fragment FLOAT_VALUE3 : DIGIT+;
