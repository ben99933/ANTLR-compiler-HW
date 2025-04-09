grammar myChecker;

options {
	language = Java;

}

@header {
    // import packages here.
    import java.util.HashMap;
}

@members {
    boolean TRACEON = false;
    HashMap<String,Integer> symbolTable = new HashMap<String,Integer>();

    public static enum TypeInfo {
        INT, FLOAT, CHAR, BOOL, ERROR, NOTEXIST
    }

}

program
    :   type MAIN '(' ')' '{' statements '}' {if (TRACEON) System.out.println("program: type MAIN '(' ')' '{' statements '}'");}
    ;

type returns [int attr_type]
    :   BOOL_TYPE       {if (TRACEON) System.out.println("type: BOOL_TYPE"); $attr_type = TypeInfo.INT.ordinal();}
    |   CHAR_TYPE       {if (TRACEON) System.out.println("type: CHAR_TYPE"); $attr_type = TypeInfo.CHAR.ordinal();}
    |   INT_TYPE        {if (TRACEON) System.out.println("type: INT_TYPE"); $attr_type = TypeInfo.INT.ordinal();}
    |   FLOAT_TYPE      {if (TRACEON) System.out.println("type: FLOAT_TYPE"); $attr_type = TypeInfo.FLOAT.ordinal();}
    ;

declaration
    :   type ID {
            if (TRACEON) System.out.println("declaration: type ID");
            if (symbolTable.containsKey($ID.text)) {
                System.out.println("Error: Variable " + $ID.text + " has been declared.");
            } else {
                symbolTable.put($ID.text, $type.attr_type);
            }
        }
    ;


functionReturn returns [int attr_type]
    :   RETURN arithmeticExpression {if (TRACEON) System.out.println("functionReturn: RETURN arithmeticExpression "); $attr_type = $arithmeticExpression.attr_type;}
    ;

arithmeticExpression returns [int attr_type]:
    condOrExpression {if (TRACEON) System.out.println("arithmeticExpression: condOrExpression"); $attr_type = $condOrExpression.attr_type;}
    ;
condOrExpression returns [int attr_type]:
    a=condAndExpression{
        $attr_type = $a.attr_type;
    } (COND_OR b=condAndExpression{
        if ($a.attr_type != $b.attr_type) {
            System.out.println("Error:" +$COND_OR.getLine() + " Type mismatch for the operator ||.");
            $attr_type = TypeInfo.ERROR.ordinal();
        }else{
            $attr_type = TypeInfo.INT.ordinal();
        }
    })* {if (TRACEON) System.out.println("condOrExpression: condAndExpression (COND_OR condAndExpression)*");}
    ;
condAndExpression returns [int attr_type]:
    a=relationalExpression{
        $attr_type = $a.attr_type;
    } ((EQUALS | NOTEQUALS) b=relationalExpression{
        if ($a.attr_type != $b.attr_type) {
            System.out.println("Error:" + $b.start.getLine() + " :Type mismatch for the operator ==, !=.");
            $attr_type = TypeInfo.ERROR.ordinal();
        }else{
            $attr_type = TypeInfo.INT.ordinal();
        }
    })* {if (TRACEON) System.out.println("condAndExpression: relationalExpression ((EQUALS | NOTEQUALS) relationalExpression)*");}
    ;
relationalExpression returns [int attr_type]:
    a=addExpresion{
        $attr_type = $a.attr_type;
    } ((LESSTHAN | LESSEQ| GREATERTHAN | GREATEQ) b=addExpresion{
        if ($a.attr_type != $b.attr_type) {
            System.out.println("Error:" + $b.start.getLine() +" :Type mismatch for the operator <, <=, >, >=.");
            $attr_type = TypeInfo.ERROR.ordinal();
        }else{
            $attr_type = TypeInfo.INT.ordinal();
        }
    })* {if (TRACEON) System.out.println("relationalExpression: addExpresion ((LESSTHAN | LESSEQ | GREATERTHAN | GREATEQ) addExpresion)*");}
    ;
addExpresion returns [int attr_type]:
    a=multiplyExpresion{
        $attr_type = $a.attr_type;
    } ((PLUS | MINUS) b=multiplyExpresion{

        if ($a.attr_type != $b.attr_type) {
            System.out.println("Error:" + $b.start.getLine() +": Type mismatch for the operator +, -.");
            $attr_type = TypeInfo.ERROR.ordinal();
        }else{
            $attr_type = $a.attr_type;
        }
    })* {if (TRACEON) System.out.println("addExpresion: multiplyExpresion ((PLUS | MINUS) multiplyExpresion)*");}
    ;
multiplyExpresion returns [int attr_type]:
    a=signPrimaryExpression{
            $attr_type = $a.attr_type;
        } ((MULTIPLY_OR_POINTER | DIVIDE | MOD) b=signPrimaryExpression{
            if ($a.attr_type != $b.attr_type) {
                System.out.println("Error:" + $b.start.getLine() +": Type mismatch for the operator *, /, \\%.");
                $attr_type = TypeInfo.ERROR.ordinal();
            }else{
                $attr_type = $a.attr_type;
            }
        })* {if (TRACEON) System.out.println("multiplyExpresion: signPrimaryExpression ((MULTIPLY_OR_POINTER | DIVIDE | MOD) signPrimaryExpression)*");}
    ;

signPrimaryExpression returns [int attr_type]
    :   primaryExpression {if (TRACEON) System.out.println("signPrimaryExpression: primaryExpression"); $attr_type = $primaryExpression.attr_type;}
    |   MINUS primaryExpression {
            if ($primaryExpression.attr_type != TypeInfo.INT.ordinal() && $primaryExpression.attr_type != TypeInfo.FLOAT.ordinal()) {
                System.out.println("Error:" + $MINUS.getLine() +": Unitary operator '-' can only be applied to int or float.");
                $attr_type = TypeInfo.ERROR.ordinal();
            }else{
                $attr_type = $primaryExpression.attr_type;
            }
        }
    ;

primaryExpression returns [int attr_type]
    :   INTEGER_VALUE {if (TRACEON) System.out.println("primaryExpression: INTEGER_VALUE"); $attr_type = TypeInfo.INT.ordinal();}
    |   FLOATING_VALUE {if (TRACEON) System.out.println("primaryExpression: FLOATING_VALUE"); $attr_type = TypeInfo.FLOAT.ordinal();}
    |   ID {if (TRACEON) System.out.println("primaryExpression: ID");}
    |   CHAR_VALUE {if (TRACEON) System.out.println("primaryExpression: CHAR_VALUE"); $attr_type = TypeInfo.CHAR.ordinal();}
    |   '(' arithmeticExpression ')' {if (TRACEON) System.out.println("primaryExpression: '(' expression ')'"); $attr_type = $arithmeticExpression.attr_type;}
    |   functionReturn {if (TRACEON) System.out.println("primaryExpression: functionReturn"); $attr_type = $functionReturn.attr_type;}
    |   BOOL_VALUE {if (TRACEON) System.out.println("primaryExpression: BOOL_VALUE"); $attr_type = TypeInfo.INT.ordinal();}
    ;


statements
    :   statement statements {if (TRACEON) System.out.println("statements: statement statements");}
    |
    ;
statement
    :   assignmentStatement';' {if (TRACEON) System.out.println("statement: assignmentStatement';'");}
    |   declaration ';' {if (TRACEON) System.out.println("statement: declaration';'");}
    |   ifStatement {if (TRACEON) System.out.println("statement: ifStatement");}
    |   forStatement {if (TRACEON) System.out.println("statement: forStatement");}
    |   whileStatement {if (TRACEON) System.out.println("statement: whileStatement");}
    |   controlStatement {if (TRACEON) System.out.println("statement: controlStatement");}
//    |   (INCREMENT | DECREMENT) ID ';' {if (TRACEON) System.out.println("statement: (INCREMENT | DECREMENT) ID ';'");}
//    |   ID (INCREMENT | DECREMENT) ';' {if (TRACEON) System.out.println("statement: ID (INCREMENT | DECREMENT) ';'");}
    ;
assignmentStatement returns [int attr_type]
    :   ID{
            if (!symbolTable.containsKey($ID.text)) {
                System.out.println("Error:" + $ID.getLine() + ": Variable " + $ID.text + " has not been declared.");
                $attr_type = TypeInfo.ERROR.ordinal();
            }else{
                $attr_type = symbolTable.get($ID.text);
            }
        } assign arithmeticExpression {
            if (TRACEON) System.out.println("assignmentStatement: ID ASSIGN arithmeticExpression");
            if ($attr_type != $arithmeticExpression.attr_type) {
                System.out.println("Error:" + $assign.start.getLine() + ": Type mismatch for the two sides of an assignment.");
                $attr_type = TypeInfo.ERROR.ordinal();
            }else{
                $attr_type = $arithmeticExpression.attr_type;
            }
        }
    |   arithmeticExpression{$attr_type = $arithmeticExpression.attr_type;}
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

ifStatement
    :   IF '(' arithmeticExpression{
            if ($arithmeticExpression.attr_type != TypeInfo.INT.ordinal()) {
                System.out.println("Error:" + $IF.getLine() +": Condition must be a boolean type.");
            }
    } ')' blockStatement {if (TRACEON) System.out.println("ifStatement: IF '(' arithmeticExpression ')' blockStatement");}
    |   IF '(' arithmeticExpression{
            if ($arithmeticExpression.attr_type != TypeInfo.INT.ordinal()) {
                System.out.println("Error:" + $IF.getLine() +": Condition must be a boolean type.");
            }
    } ')' blockStatement  ELSE blockStatement  {if (TRACEON) System.out.println("ifStatement: IF '(' arithmeticExpression ')' blockStatement  ELSE blockStatement");}
    ;

forStatement
    :   FOR '(' (declaration|assignmentStatement) ';' arithmeticExpression{
            if ($arithmeticExpression.attr_type != TypeInfo.INT.ordinal()) {
                System.out.println("Error:" + $FOR.getLine() +": Condition must be a boolean type.");
            }
    } ';' assignmentStatement ')' blockStatement {if (TRACEON) System.out.println("forStatement: FOR '(' (declaration|assignmentStatement) ';' arithmeticExpression ';' assignmentStatement ')' blockStatement");}
    ;
whileStatement
    :   WHILE '(' arithmeticExpression{
            if ($arithmeticExpression.attr_type != TypeInfo.INT.ordinal()) {
                System.out.println("Error:" + $WHILE.getLine() +": Condition must be a boolean type.");
            }
    } ')' blockStatement {if (TRACEON) System.out.println("whileStatement: WHILE '(' arithmeticExpression ')' blockStatement");}
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
BOOL_VALUE      : TRUE | FALSE;
WHITE_SPACE   : [ \t\r\n]+ -> skip;
//WHITE_SPACE     : [ \t\r\n]+;
TRUE            : 'true';
FALSE           : 'false';

//==================================Fragments==================================

//basic
fragment DIGIT  : '0'..'9';
fragment LETTER : [a-zA-Z_];
fragment ESC    : '\\' .;

// Floating point literals
fragment FLOAT_VALUE1 : DIGIT+ '.' DIGIT*;
fragment FLOAT_VALUE2 : '.' DIGIT+;
fragment FLOAT_VALUE3 : DIGIT+;
