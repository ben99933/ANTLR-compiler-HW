grammar myChecker;
options {
	language = Java;

}

@header {
    // import packages here.
    import java.util.HashMap;
}

@members {
    boolean TRACEON = true;
    HashMap<String,Integer> symbolTable = new HashMap<String,Integer>();

    public static enum TypeInfo {
        INT, FLOAT, CHAR, BOOL, ERROR, NOTEXIST
    }

}

program
    :   type MAIN '(' ')' '{' statements '}'			{ if (TRACEON) System.out.println("program: INT MAIN '(' ')' '{' statements '}'");}
    ;
//function:
//    type ID '(' (type ID (',' type ID)*)* ')' '{' statements '}'	{ if (TRACEON) System.out.println("function: type ID '(' type ID (',' type ID)* ')' '{' statements '}'");}
//    ;

type returns [int attr_type]
    :   INT					{ if (TRACEON) System.out.println("type: INT"); 			$attr_type = TypeInfo.INT.ordinal();}
    |   FLOAT				{ if (TRACEON) System.out.println("type: FLOAT"); 			$attr_type = TypeInfo.FLOAT.ordinal();}
    |   CHAR				{ if (TRACEON) System.out.println("type: CHAR"); 			$attr_type = TypeInfo.CHAR.ordinal();}
	|	BOOL				{ if (TRACEON) System.out.println("type: BOOL"); 			$attr_type = TypeInfo.BOOL.ordinal();}
    ;

declarations:
    a=type b=ID
        {
            if (TRACEON) System.out.println("declarations: type expression, ID="  + $b.getText());
            if (symbolTable.containsKey($b.getText())){
                System.out.println("Error: " +  $b.getLine() +  ": Redeclared identifier.");
            }
            else{
                symbolTable.put($b.getText(), $a.attr_type);
            }
        }
        ( '=' d=expression
            {
                if($d.attr_type != $a.attr_type){
                    System.out.println("Error: " +  $a.start.getLine() + ": Mismatch type for the operator = in an expression.");
                }
            }
        )?
        (',' c = ID {
            if (symbolTable.containsKey($c.getText())){
                System.out.println("Error: " +  $c.getLine() +  ": Redeclared identifier.");
            }
            else{
                symbolTable.put($c.getText(), $a.attr_type);
            }
        }( '=' e=expression
            {
                if($e.attr_type != $a.attr_type){
                    System.out.println("Error: " +  $a.start.getLine() + ": Mismatch type  for the operator = in an expression.");
                }
            }
        )?)*
        ';'
    ;


expression returns [int attr_type]
    :   a = equalExpression {$attr_type = $a.attr_type;}
	(assignOperator  b = equalExpression
		{
			if ($a.attr_type != $b.attr_type) {
				System.out.println("Error: " +  $a.start.getLine() + ": Type mismatch for the two sides of an assignment.");
				$attr_type = TypeInfo.ERROR.ordinal();
			}
		}
	)*
    ;

assignOperator
    :   ASSIGN  			{ if (TRACEON) System.out.println("assignExpr: ASSIGN"); }
    |   ASSIGN_ADD  	 		{ if (TRACEON) System.out.println("assignExpr: ASSIGN_ADD"); }
    |   ASSIGN_SUB  			{ if (TRACEON) System.out.println("assignExpr: ASSIGN_SUB"); }
    |   ASSIGN_MUL  			{ if (TRACEON) System.out.println("assignExpr: ASSIGN_MUL"); }
    |   ASSIGN_DIV  			{ if (TRACEON) System.out.println("assignExpr: ASSIGN_DIV"); }
    |   ASSIGN_MOD  			{ if (TRACEON) System.out.println("assignExpr: ASSIGN_MOD"); }
    ;

equalExpression returns [int attr_type]
    :   a = compareExpression {$attr_type = $a.attr_type;}
	(eqCompare b = compareExpression
		{
			$attr_type = TypeInfo.BOOL.ordinal();
			if ($a.attr_type != $b.attr_type) {
				System.out.println("Error: " +  $a.start.getLine() + ": Mismatch Type for the operator ==, != in an expression.");
				$attr_type = TypeInfo.ERROR.ordinal();
			}
		})*
    ;

eqCompare
    :   CMP_EQ  		{ if (TRACEON) System.out.println("equalExpression: CMP_EQ "); }
    |   CMP_NEQ  		{ if (TRACEON) System.out.println("equalExpression: CMP_NEQ "); }
    ;

compareExpression returns [int attr_type]
    :   a = arithmeticExpression {$attr_type = $a.attr_type;}
	(comparator b = arithmeticExpression
		{
			$attr_type = TypeInfo.BOOL.ordinal();
			if ($a.attr_type != $b.attr_type) {
				System.out.println("Error: " +  $a.start.getLine() + ": Mismatch Type for the operator >, >=, <, <= in an expression.");
				$attr_type = TypeInfo.ERROR.ordinal();
			}
		})*
    ;

comparator
    :   CMP_GT  		{ if (TRACEON) System.out.println("compareExpression: CMP_GT"); }
    |   CMP_LT  		{ if (TRACEON) System.out.println("compareExpression: CMP_LT"); }
    |   CMP_GEQ  		{ if (TRACEON) System.out.println("compareExpression: CMP_GEQ"); }
    |   CMP_LEQ  		{ if (TRACEON) System.out.println("compareExpression: CMP_LEQ"); }
    ;

arithmeticExpression returns [int attr_type]
    :   a = multiplyExpression {$attr_type = $a.attr_type;}
	(arithmeticOperator b = multiplyExpression
		{
			if ($a.attr_type != $b.attr_type) {
				System.out.println("Error: " +  $a.start.getLine() + ": Mismatch Type for the operator +, - in an expression.");
				$attr_type = TypeInfo.ERROR.ordinal();
			}
		})*
    ;

// 跟addition 相同順位的運算子
arithmeticOperator
    :   OP_ADD  		{ if (TRACEON) System.out.println("arithmeticExpression: +"); }
    |   OP_SUB  		{ if (TRACEON) System.out.println("arithmeticExpression: -"); }
    ;

multiplyExpression returns [int attr_type]
    :   a = primaryExpression {$attr_type = $a.attr_type;}
	(multiplayOperator b = primaryExpression
		{
			if ($a.attr_type != $b.attr_type) {
				System.out.println("Error: " +  $a.start.getLine() + ": Mismatch Type for the operator *, /, \\% in an expression.");
				$attr_type = TypeInfo.ERROR.ordinal();
			}
		})*
    ;

// 跟multiply 相同順位的運算子
multiplayOperator returns [int attr_type]
    :   OP_MUL_PTR  		{ if (TRACEON) System.out.println("multiplyExpression: *"); }
    |   OP_DIV  		{ if (TRACEON) System.out.println("multiplyExpression: /"); }
    |   OP_MOD  		{ if (TRACEON) System.out.println("multiplyExpression: \\%"); }
    ;

primaryExpression returns [int attr_type]
    :   INT_VALUE			{ if (TRACEON) System.out.println("primaryExpression: INT_VALUE");		$attr_type = TypeInfo.INT.ordinal();}
    |   FLOAT_VALUE		{ if (TRACEON) System.out.println("primaryExpression: FLOAT_VALUE");	$attr_type = TypeInfo.FLOAT.ordinal();}
    |   ID
		{
			if (TRACEON) System.out.println("primaryExpression: ID");
			if (!symbolTable.containsKey($ID.getText())){
				System.out.println("Error: " +  $ID.getLine() +  ": Variable must be declared before it is used.");
				$attr_type = TypeInfo.NOTEXIST.ordinal();
			}
			else{
				$attr_type = symbolTable.get($ID.getText());
			}
		}
    |   '(' expression ')'	{ if (TRACEON) System.out.println("primaryExpression: ( expression )");		$attr_type = $expression.attr_type;}
	|   CHAR_VALUE		{ if (TRACEON) System.out.println("primaryExpression: CHAR_VALUE"); $attr_type = TypeInfo.CHAR.ordinal();}
	|	BOOL_VALUE		{ if (TRACEON) System.out.println("primaryExpression: TRUE"); $attr_type = TypeInfo.BOOL.ordinal();}
    ;


statements
    :   statement statements                                                { if (TRACEON) System.out.println("statements: statement statements");}
    |                                                                       { if (TRACEON) System.out.println("statements: ");}
    ;

statement
    :   declarations                                                    { if (TRACEON) System.out.println("statement: declarations ';' ");}
    |   expression ';'                                                            { if (TRACEON) System.out.println("statement: expr; ");}
    |   ifStatement                                                       { if (TRACEON) System.out.println("statement: ifStatement");}
    |   whileStatement                                                  { if (TRACEON) System.out.println("statement: whileStatement");}
    |   doStatement                                                    { if (TRACEON) System.out.println("statement: doStatement");}
    |   (CONTINUE | BREAK) ';'                                            { if (TRACEON) System.out.println("statement: (CONTINUE | BREAK) ';' ");}
    |   forStatement                                                { if (TRACEON) System.out.println("statement: forStatement");}
    |   RETURN expression* ';'                                                   { if (TRACEON) System.out.println("statement: RETURN expr* ';'");}
	;

ifStatement:
    c=IF '(' a = expression ')' blockStatement  (d=ELSE IF  '(' b = expression ')' blockStatement)* (e=ELSE blockStatement)?
        {
            if ($a.attr_type != TypeInfo.BOOL.ordinal()) System.out.println("Error: " +  $c.getLine() +  ": Condition's type must be boolean.");
            if ($b.attr_type != TypeInfo.BOOL.ordinal()) System.out.println("Error: " +  $d.getLine() +  ": Condition's type must be boolean.");
        }
    ;

whileStatement:
    WHILE '(' a = expression ')' blockStatement
        {
            if (TRACEON) System.out.println("statement: WHILE '(' expression ')' instatements ");
            if ($a.attr_type != TypeInfo.BOOL.ordinal()) System.out.println("Error: " +  $WHILE.getLine() +  ": Condition's type must be boolean.");
        }
    ;

forStatement:
   FOR '(' b=declarations a=expression c=expression ')' d=blockStatement
	{
		if ($a.attr_type != TypeInfo.BOOL.ordinal()) System.out.println("Error: " +  $a.start.getLine() +  ": Condition's type must be boolean.");
	}
    ;
doStatement:
    DO b=blockStatement WHILE '(' a = expression ')' ';'
    {
        if (TRACEON) System.out.println("statement: DO instatements WHILE '(' expression ')' ';'");
        if ($a.attr_type != TypeInfo.BOOL.ordinal()) System.out.println("Error: " +  $WHILE.getLine() +  ": Condition's type must be boolean.");
    }
    ;

blockStatement
    :   statement                                                           { if (TRACEON) System.out.println("instatements: statement");}
    |   '{' statements '}'                                                  { if (TRACEON) System.out.println("instatements:  {statements}");}
    ;





//Reserved Keywords

INT                : 'int';
FLOAT              : 'float';
BOOL 			   : 'bool';
CHAR               : 'char';

FOR               : 'for';
IF                : 'if';
ELSE              : 'else';
DO                : 'do';
WHILE             : 'while';
CONTINUE          : 'continue';
BREAK             : 'break';
RETURN            : 'return';

//Comments
COMMENT_SINGLE          : '//'(.)*?'\n' ->skip;
COMMENT_MULTI           : '/*'(.)*?'*/' ->skip;


/*----------------------*/
/*  Compound Operators  */
/*----------------------*/
CMP_EQ              : '==';
CMP_NEQ              : '!=';
CMP_GT              : '>';
CMP_LT              : '<';
CMP_GEQ              : '>=';
CMP_LEQ              : '<=';

OP_ADD             : '+';
OP_SUB             : '-';
OP_MUL_PTR           : '*';
OP_DIV             : '/';
OP_MOD             : '%';

COND_NOT             : '!';
COND_OR             : '||';
COND_AND            : '&&';

ASSIGN             : '=';
ASSIGN_ADD            : '+=';
ASSIGN_SUB           : '-=';
ASSIGN_MUL            : '*=';
ASSIGN_DIV            : '/=';
ASSIGN_MOD            : '%=';
ASSIGN_BITAN         : '&=';
ASSIGN_BITOR         : '|=';
ASSIGN_XOR            : '^=';

COMMA           : ',';
SEMICOLON       : ';';
LPAREN          : '(';
RPAREN          : ')';
LBRACE          : '{';
RBRACE          : '}';
LBRACK          : '[';
RBRACK          : ']';


/*----------------------*/
/*        Others        */
/*----------------------*/
MAIN               :'main';
NULL               : 'NULL';


// Macro
INCLUDE         : 'include<'  ID '.h>';
DEFINE          : 'define';
IFDEF           : 'ifdef';
IFNDEF          : 'ifndef';
ENDIF           : 'endif';
UNDEF           : 'undef';
MACRO           : '#' (INCLUDE | DEFINE | IFDEF | IFNDEF | ENDIF | UNDEF) -> skip;


LITERAL            : '"'(.)*?'"';
CHAR_VALUE          : '\''(LETTER)'\'';
ID                 : (LETTER)(LETTER | DIGIT)*;
BOOL_VALUE          : TRUE | FALSE;
TRUE               : 'true';
FALSE 			   : 'false';
fragment LETTER    : 'a'..'z' | 'A'..'Z' | '_';
fragment DIGIT     : '0'..'9';




NEW_LINE           : '\n'->skip;
WS                 : (' '|'\r'|'\t'|';')+ ->skip;

/*----------------------*/
/*     Number Type      */
/*----------------------*/
INT_VALUE            : ('0' | ('1'..'9')(DIGIT)*);

FLOAT_VALUE          : FLOAT_NUM1 | FLOAT_NUM2 | FLOAT_NUM3;
fragment FLOAT_NUM1: (DIGIT)+'.'(DIGIT)*;
fragment FLOAT_NUM2: '.'(DIGIT)+;
fragment FLOAT_NUM3: (DIGIT)+;