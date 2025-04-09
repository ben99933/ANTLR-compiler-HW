lexer grammar mylexer;

options {
    language = Java;
}

// Keywords
TYPEDEF     : 'typedef';
SIZEOF      : 'sizeof';
EXTERN      : 'extern';

//===========================data type===========================
UNSIGNED_TYPE   : 'unsigned';
SIGNED_TYPE     : 'signed';
SHORT_TYPE      : 'short';
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
//LINE_COMMENT    : '//' ~[\r\n]* -> skip;
//BLOCK_COMMENT   : '/*' .*? '*/' -> skip;
LINE_COMMENT    : '//' ~[\r\n]*;
BLOCK_COMMENT   : '/*' .*? '*/';

//
LOGIC_AND       : '&';
LOGIC_OR        : '|';
RSHIFT          : '>>';
LSHIFT          : '<<';

MOD             : '%';
DIVIDE          : '/';
MULTIPLY        : '*';
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

// Macro
INCLUDE         : 'include' (' ')* HEADER;
DEFINE          : 'define';
IFDEF           : 'ifdef';
IFNDEF          : 'ifndef';
ENDIF           : 'endif';
UNDEF           : 'undef';
HEADER          : '<' ((ID)+ '/')* (ID)+  '.h>';
MACRO           : '#' (INCLUDE | DEFINE | IFDEF | IFNDEF | ENDIF | UNDEF);

// Identifiers and literals
NULL            : 'NULL';
ID              : LETTER (LETTER | DIGIT)*;
INT_VALUE       : '0' | (('1'..'9')DIGIT*);
FLOAT_VALUE     : FLOAT_VALUE1 | FLOAT_VALUE2 | FLOAT_VALUE3;
CHAR_VALUE      : '\'' (ESC | ~['\\]) '\'';
STRING_VALUE    : '"' (ESC | ~["\\])* '"';
//WHITE_SPACE   : [ \t\r\n]+ -> skip;
WHITE_SPACE     : [ \t\r\n]+;


//==================================Fragments==================================

//basic
fragment DIGIT  : '0'..'9';
fragment LETTER : [a-zA-Z_];
fragment ESC    : '\\' .;

// Floating point literals
fragment FLOAT_VALUE1 : DIGIT+ '.' DIGIT*;
fragment FLOAT_VALUE2 : '.' DIGIT+;
fragment FLOAT_VALUE3 : DIGIT+;
