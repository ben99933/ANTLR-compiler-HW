grammar myCompiler;
options {
    language = Java;
}
@header {
     import java.util.HashMap;
     import java.util.ArrayList;
     import java.util.List;
}

@members{
    boolean TRACEON = false;


    //第三次作業有用到的東東拿來改
    //但是真的用到的只有ERROR INT INT_CONST
    enum Type{
        ERROR, BOOL, INT, INT_CONST, FLOAT, FLOAT_CONST, CHAR, STRING;
    };
    class Info{
        public Type type;
        public Temp value;
        public Info(){
            this.type = Type.ERROR;
            this.value = new Temp();
        }
        public Info setType(Type type){
            this.type = type;
            return this;
        }
        public Info setValue(Temp value){
            this.value = value;
            return this;
        }
    }

    class Temp{
        public int index;
        public int intValue;
        public String stringValue;
        public float floatValue;
        public Temp setVar(int var){
            this.index = var;
            return this;
        }
        public Temp setIntValue(int intValue){
            this.intValue = intValue;
            return this;
        }
        public Temp setStringValue(String stringValue){
            this.stringValue = stringValue;
            return this;
        }
        public Temp setFloatValue(float floatValue){
            this.floatValue = floatValue;
            return this;
        }
    }

    class ParameterPrint{
        int varNum;
        String para;
        public ParameterPrint(){
            this.varNum = 0;
            this.para = new String();
        }
    }
    HashMap<String, Info> symbolTable = new HashMap<String, Info>();

    int labelCount = 0; //temp label count
    int variableCount = 0; //temp variable count

    int layer = 0; //record the layer of the code
    // record all asm code
    List<String> textCode = new ArrayList<String>();

    /*
    * Output prologue.
    */
    void prologue() {
      genComment("==== prologue ====");
      genCode("declare dso_local i32 @printf(i8*, ...)\n");
      genCode("define dso_local i32 @main()");
      genCode("{");
      layer ++;
    }
    void genComment(String comment){
        textCode.add("; " + comment);
    }
    void genLabel(String Label){
        textCode.add(Label + ":");
    }
    void genCode(String code){
        for(int i = 0; i < layer; i++){
            code = "    " + code;
        }
        textCode.add(code);
    }


    /*
     * Output epilogue.
     */
    void epilogue()
    {
       /* handle epilogue */
      genComment("=== epilogue ===");
      genCode("ret i32 0");
      layer--;
      genCode("}");
      
    }


    String newLabel() {
      labelCount ++;
      return ("L" + labelCount);
    }


    public List<String> getTextCode() {
        return textCode;
    }
    
    void error(String format, Object ... args) {
        System.out.println("Error: " + String.format(format, args));
        System.exit(0);
    }
    void debug(String string){
        if(!TRACEON)return;
        System.out.println(string);
    }


}

// ===============================Parser Rule====================================

program
   : (INT|VOID) MAIN '(' ')'
   {
      /* Output function prologue */
      prologue();
   }
   '{'
      declarations
      statements
      (RETURN arithmeticExpression? ';')?
   '}'
   {
      debug("VOID MAIN () {declarations statements}");
      /* output function epilogue */
      epilogue();
   }

   ;
//
//functionDeclaration
//   : type ID '(' type ID ')' '{'sta'}'
//
//   ;

declarations
   :  type ID ';' declarations
        {
            debug("declarations: type ID : declarations");

            if (symbolTable.containsKey($ID.text)) {
             // 報錯重複宣告
               error("%d, Redeclared ID.", $ID.getLine());
            }

            /* Add ID and its info into the symbol table. */
            Info info = new Info().setType($type.attr_type);
            info.value.index = variableCount;
            variableCount ++;
            symbolTable.put($ID.text, info);

//            switch($type.attr_type){
//                case Type.INT:
//                    genCode("%t" + info.value.index + " = alloca i32, align 4");
//                    break;
//                case Type.FLOAT:
//                    genCode("%t" + info.value.index + " = alloca float, align 4");
//                    break;
//                default: break;
//            }

            if ($type.attr_type == Type.INT) {
                genCode("%t" + info.value.index + " = alloca i32, align 4");
            }
            else if ($type.attr_type == Type.FLOAT) {
                genCode("%t" + info.value.index + " = alloca float, align 4");
            }




        }
   | type ID '=' arithmeticExpression ';' declarations
        {
            debug("declarations: type ID : declarations");

            if (symbolTable.containsKey($ID.text)) {
                // 報錯重複宣告
                  error("%d, Redeclared ID.", $ID.getLine());
            }

            /* Add ID and its info into the symbol table. */
            Info info = new Info().setType($type.attr_type);
            info.value.index = variableCount;
            variableCount ++;
            symbolTable.put($ID.text, info);

            if ($type.attr_type == Type.INT) {
                genCode("%t" + info.value.index + " = alloca i32, align 4");
            }
            else if ($type.attr_type == Type.FLOAT) {
                genCode("    %t" + info.value.index + " = alloca float, align 4");
            }

            Info RHS = $arithmeticExpression.info;
            Info LHS = symbolTable.get($ID.text);

            if(LHS.type == Type.INT){
                String code1 = "";
                String code2 = ", i32* %t" + LHS.value.index;
                if(RHS.type==Type.INT)code1 = "store i32 %t" + RHS.value.index;
                if(RHS.type==Type.INT_CONST)code1 = "store i32 " + RHS.value.intValue;
                String code = code1 + code2;
                genCode(code);

            }
            if(LHS.type==Type.FLOAT){
                String code1 = "";
                String code2 = ", float* %t" + LHS.value.index + ", align 4";
                if(RHS.type == Type.FLOAT)code1 = "store float %t" + RHS.value.index;
                if(RHS.type == Type.FLOAT_CONST)code1 = "store float " + String.format("%e",RHS.value.floatValue);
                String code = code1 + code2;
                genCode(code);

            }
        }
   |
       {
          debug("declarations: ");
       }
   ;


type returns [Type attr_type]
   : INT { debug("type: INT"); $attr_type=Type.INT; }
   | CHAR { debug("type: CHAR"); $attr_type=Type.CHAR; }
   | FLOAT {debug("type: FLOAT"); $attr_type=Type.FLOAT; }
   ;


statements
   : statement statements
   |
   ;


statement
   : assignStatement ';'
   | ifStatement
   | functionStatementNoReturn ';'
   | forStatement
   | whileStatement
   ;






/*
L1: assingment
    goto L2
L2: condition check
    if true goto L3
    else goto L5
L4: iteration
    goto L2
L3: block statement
    goto L4
L5: end of loop
*/
forStatement returns [String label] @init {$label = new String();}
   : FOR{
            String L1 = newLabel();
            String L2 = newLabel();
            String L3 = newLabel();
            String L4 = newLabel();
            String L5 = newLabel();
            $label = L5;
        }
    '('
        {
            genCode("br label %" + L1);
            genLabel(L1);
        }
    assignStatement
        {
            genCode("br label %" + L2);
            genLabel(L2);
        }
    ';' conditionExpression
        {
            genCode("br i1 %t" + $conditionExpression.info.value.index + ", label %" + L3 + ", label %" + L5);
            genLabel(L4);
        }
    ';' assignStatement
        {
            genCode("br label %" + L2);
            genLabel(L3);
        }
    ')' blockStatement
        {
            genCode("br label %" + L4);
            genLabel(L5);
        }
   ;

/*
    L1: condition check
        if true goto L2
        else goto L3
    L2: block statement
        goto L1
    L3: end of loop
*/
whileStatement returns [String label] @init {$label = new String();}
    : WHILE{
                String L1 = newLabel();
                String L2 = newLabel();
                String L3 = newLabel();
                $label = L3;
            }
    '('
        {
            genCode("br label %" + L1);
            genLabel(L1);
        }
    conditionExpression
        {
            genCode("br i1 %t" + $conditionExpression.info.value.index + ", label %" + L2 + ", label %" + L3);
            genLabel(L2);
        }
    ')' blockStatement
        {
            genCode("br label %" + L1);
            genLabel(L3);
        }
    ;


ifStatement returns [String label] @init {$label = new String();}
   : a=ifThenStatement
   {
      String then = $a.label;
      String end = newLabel();
      $label = end;
      genCode("br label %" + $label);
      genLabel(then);
   }
   (ELSE b=ifThenStatement
   {
      String next = $b.label;
      genCode("br label %" + $label);
      genLabel(next);
   })*

   //elseStatement 包含 epsilon
   elseStatement[$label]
   {
      genCode("br label %" + $label);
      genLabel($label);
   }
   ;
ifThenStatement returns [String label] @init {$label = new String();}
   : IF '(' conditionExpression ')'
   {
      String L1 = newLabel();
      String L2 = newLabel();
      genCode("br i1 %t" + $conditionExpression.info.value.index + ", label %" + L1 + ", label %" + L2);
      genLabel(L1);
      $label = L2;
   }
   blockStatement
   ;
elseStatement[String label]
   : ELSE blockStatement
   |
   ;


blockStatement
   : '{' statements '}'
   ;


assignStatement
   : ID '=' arithmeticExpression
        {
            Info LHS = symbolTable.get($ID.text);
            Info RHS = $arithmeticExpression.info;

            if(LHS.type == Type.INT){
                String code1 = "";
                String code2 = ", i32* %t" + LHS.value.index;
                if(RHS.type==Type.INT)code1 = "store i32 %t" + RHS.value.index;
                if(RHS.type==Type.INT_CONST)code1 = "store i32 " + RHS.value.intValue;
                String code = code1 + code2;
                genCode(code);

            }

            if(LHS.type == Type.FLOAT){
                String code1 = "";
                String code2 = ", float* %t" + LHS.value.index + ", align 4";
                if(RHS.type == Type.FLOAT)code1 = "store float %t" + RHS.value.index;
                if(RHS.type == Type.FLOAT_CONST)code1 = "store float " + String.format("%e",RHS.value.floatValue);
                String code = code1 + code2;
                genCode(code);
            }
        }


   ;

functionStatementNoReturn
   :  'printf' '(' arguments[1] ')'
   |  ID '(' arguments[0] ')'
   ;


arguments[int flag] returns [ParameterPrint thepara] @init {$thepara = new ParameterPrint();}
   : a = argument
        {
            if(flag == 1){
                int len = $a.info.value.stringValue.length()+1;
                String s = $a.info.value.stringValue;
                if (s.endsWith("\\n")) len--;

                s = s.replace("\\n","\\0A");
                textCode.add(1 , "@t"+ variableCount + " = constant [" + len + " x i8] c\"" + s + "\\00\"");
                $thepara.varNum = variableCount;
                variableCount ++;
            }
        }
   (',' b = argument
       {
          String rec = ", i32 %t"+ $b.info.value.index;
          $thepara.para += rec;
       }
   )*
       {
          if(flag == 1){
             int len = $a.info.value.stringValue.length() +1;
             String s = $a.info.value.stringValue;
             if (s.endsWith("\\n")) len--;

             genCode("call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([" + len + " x i8], [" + len +" x i8]* @t" + $thepara.varNum + ", i32 0, i32 0)" + $thepara.para + ")");
             variableCount ++;
          }
       }
   ;

argument returns [Info info] @init {$info = new Info();}
   : arithmeticExpression  { $info=$arithmeticExpression.info; }
   | STRING_VALUE
        {
            String s = $STRING_VALUE.text;
            $info.setType(Type.STRING);
            $info.value.stringValue = s.substring(1, s.length() - 1);
        }
   ;

conditionExpression returns [Info info] @init {$info = new Info();}
   : a=arithmeticExpression ( '>' b=arithmeticExpression
        {
            boolean flag = false;
            if (($a.info.type == Type.INT) && ($b.info.type == Type.INT)) {
                genCode("%t"+ variableCount +" = icmp sgt i32 %t"+$a.info.value.index +", %t"+$b.info.value.index);
                flag = true;
            }
            else if (($a.info.type == Type.INT) && ($b.info.type == Type.INT_CONST)) {
                genCode("%t"+ variableCount +" = icmp sgt i32 %t"+$a.info.value.index +", "+$b.info.value.intValue);
                flag = true;
            }
            else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT)) {
                genCode("%t"+ variableCount +" = icmp sgt i32 "+$a.info.value.intValue +", %t"+$b.info.value.index);
                flag = true;
            }
            else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT_CONST)) {
                genCode("%t"+ variableCount +" = icmp sgt i32 "+$a.info.value.intValue +", "+$b.info.value.intValue);
                flag = true;
            }

            if(flag){
                $info.setType(Type.INT);
                $info.value.index = variableCount;
                variableCount ++;
            }

        }
   | '<' b=arithmeticExpression
       {
            boolean flag = false;
            if (($a.info.type == Type.INT) && ($b.info.type == Type.INT)) {
                genCode("%t"+ variableCount +" = icmp slt i32 %t"+$a.info.value.index+", %t"+$b.info.value.index);
                flag = true;
            }
            else if (($a.info.type == Type.INT) && ($b.info.type == Type.INT_CONST)) {
                genCode("%t"+ variableCount +" = icmp slt i32 %t"+$a.info.value.index+", "+$b.info.value.intValue);
                flag = true;
            }
            else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT)) {
                genCode("%t"+ variableCount +" = icmp slt i32 "+$a.info.value.intValue +", %t"+$b.info.value.index);
                flag = true;
            }
            else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT_CONST)) {
                genCode("%t"+ variableCount +" = icmp slt i32 "+$a.info.value.intValue +", "+$b.info.value.intValue);
                flag = true;
            }

            if(flag){
                $info.setType(Type.INT);
                $info.value.index = variableCount;
                variableCount ++;
            }
       }
   | '>=' b=arithmeticExpression
        {
            boolean flag = false;
            if (($a.info.type == Type.INT) && ($b.info.type == Type.INT)) {
                genCode("%t"+ variableCount +" = icmp sge i32 %t"+$a.info.value.index+", %t"+$b.info.value.index);
                flag = true;
            }
            else if (($a.info.type == Type.INT) && ($b.info.type == Type.INT_CONST)) {
                genCode("%t"+ variableCount +" = icmp sge i32 %t"+$a.info.value.index+", "+$b.info.value.intValue);
                flag = true;
            }
            else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT)) {
                genCode("%t"+ variableCount +" = icmp sge i32 "+$a.info.value.intValue +", %t"+$b.info.value.index);
                flag = true;
            }
            else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT_CONST)) {
                genCode("%t"+ variableCount +" = icmp sge i32 "+$a.info.value.intValue +", "+$b.info.value.intValue);
                flag = true;
            }

            if(flag){
                $info.setType(Type.INT);
                $info.value.index = variableCount;
                variableCount ++;
            }

        }
   | '<=' b=arithmeticExpression
        {
            boolean flag = false;
            if (($a.info.type == Type.INT) && ($b.info.type == Type.INT)) {
                genCode("%t"+ variableCount +" = icmp sle i32 %t"+$a.info.value.index+", %t"+$b.info.value.index);
                flag = true;
            }
            else if (($a.info.type == Type.INT) && ($b.info.type == Type.INT_CONST)) {
                genCode("%t"+ variableCount +" = icmp sle i32 %t"+$a.info.value.index+", "+$b.info.value.intValue);
                flag = true;
            }
            else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT)) {
                genCode("%t"+ variableCount +" = icmp sle i32 "+$a.info.value.intValue +", %t"+$b.info.value.index);
                flag = true;
            }
            else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT_CONST)) {
                genCode("%t"+ variableCount +" = icmp sle i32 "+$a.info.value.intValue +", "+$b.info.value.intValue);
                flag = true;
            }

            if(flag){
                $info.setType(Type.INT);
                $info.value.index = variableCount;
                variableCount ++;
            }

        }
   | '==' b=arithmeticExpression
       {
           boolean flag = false;
           if (($a.info.type == Type.INT) && ($b.info.type == Type.INT)) {
              genCode("%t"+ variableCount +" = icmp eq i32 %t"+$a.info.value.index+", %t"+$b.info.value.index);
              flag = true;
           }
           else if (($a.info.type == Type.INT) && ($b.info.type == Type.INT_CONST)) {
              genCode("%t"+ variableCount +" = icmp eq i32 %t"+$a.info.value.index+", "+$b.info.value.intValue);
              flag = true;
           }
           else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT)) {
              genCode("%t"+ variableCount +" = icmp eq i32 "+$a.info.value.intValue +", %t"+$b.info.value.index);
              flag = true;
           }
           else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT_CONST)) {
              genCode("%t"+ variableCount +" = icmp eq i32 "+$a.info.value.intValue +", "+$b.info.value.intValue);
              flag = true;
           }

           if(flag){
              $info.setType(Type.INT);
              $info.value.index = variableCount;
              variableCount ++;
           }

       }
   | '!=' b=arithmeticExpression
       {
          boolean flag = false;

          if (($a.info.type == Type.INT) && ($b.info.type == Type.INT)) {
             genCode("%t"+ variableCount +" = icmp ne i32 %t"+$a.info.value.index+", %t"+$b.info.value.index);
             flag = true;
          }
          else if (($a.info.type == Type.INT) && ($b.info.type == Type.INT_CONST)) {
             genCode("%t"+ variableCount +" = icmp ne i32 %t"+$a.info.value.index+", "+$b.info.value.intValue);
             flag = true;
          }
          else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT)) {
             genCode("%t"+ variableCount +" = icmp ne i32 "+$a.info.value.intValue +", %t"+$b.info.value.index);
             flag = true;
          }
          else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT_CONST)) {
             genCode("%t"+ variableCount +" = icmp ne i32 "+$a.info.value.intValue +", "+$b.info.value.intValue);
             flag = true;
          }

          if(flag){
            $info.setType(Type.INT);
            $info.value.index = variableCount;
            variableCount ++;
         }

       }
   )
   ;


arithmeticExpression returns [Info info] @init {$info = new Info();}
   : a=multiplyExpression { $info=$a.info; }
   ( '+' b=multiplyExpression
       {
          // We need to do type checking first.
          // ...
          // code generation.
          if (($a.info.type == Type.INT) && ($b.info.type == Type.INT)) {
             genCode("%t" + variableCount + " = add nsw i32 %t" + $info.value.index + ", %t" + $b.info.value.index);
             // Update arithmeticExpression's info.
             $info.setType(Type.INT);
             $info.value.index = variableCount;
             variableCount ++;
          }
          else if (($a.info.type == Type.INT) && ($b.info.type == Type.INT_CONST)) {
             genCode("%t" + variableCount + " = add nsw i32 %t" + $info.value.index + ", " + $b.info.value.intValue);
             // Update arithmeticExpression's info.
             $info.setType(Type.INT);
             $info.value.index = variableCount;
             variableCount ++;
          }
          else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT)) {
             genCode("%t" + variableCount + " = add nsw i32 " + $info.value.intValue + ", %t" + $b.info.value.index);
             // Update arithmeticExpression's info.
             $info.setType(Type.INT);
             $info.value.index = variableCount;
             variableCount ++;
          }
          else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT_CONST)) {
             genCode("%t" + variableCount + " = add nsw i32 " + $info.value.intValue + ", " + $b.info.value.intValue);
             // Update arithmeticExpression's info.
             $info.setType(Type.INT);
             $info.value.index = variableCount;
             variableCount ++;
          }

          else if (($a.info.type == Type.FLOAT) && ($b.info.type == Type.FLOAT)) {
             genCode("%t" + variableCount + " = fadd float %t" + $a.info.value.index + ", %t" + $b.info.value.index);
             $info.setType(Type.FLOAT);
             $info.value.index = variableCount;
             variableCount ++;
          }
          else if (($a.info.type == Type.FLOAT) && ($b.info.type == Type.FLOAT_CONST)) {
             genCode("%t"+ variableCount +" = fpext float %t"+ $a.info.value.index +" to double");
             int x = variableCount;
             variableCount ++;
             String f_str = String.format("%e",$b.info.value.floatValue);
             genCode("%t" + variableCount + " = fadd double %t" + x + ", " + f_str);
             int y = variableCount;
             variableCount ++;
             genCode("%t"+ variableCount +" = fptrunc double %t"+ y +" to float");
             $info.setType(Type.FLOAT);
             $info.value.index = variableCount;
             variableCount ++;
          }
          else if (($a.info.type == Type.FLOAT_CONST) && ($b.info.type == Type.FLOAT_CONST)) {
             genCode("%t"+ variableCount +" = fpext float %t"+ $a.info.value.index + ", " + $b.info.value.floatValue);
             int x = variableCount;
             variableCount ++;
             String f_str = String.format("%e",$b.info.value.floatValue);
             genCode("%t" + variableCount + " = fadd double %t" + x + ", " + f_str);
             int y = variableCount;
             variableCount ++;
             genCode("%t"+ variableCount +" = fptrunc double %t"+ y +" to float");
             $info.setType(Type.FLOAT);
             $info.value.index = variableCount;
             variableCount ++;
          }

       }
   | '-' c=multiplyExpression
       {
            boolean flag = false;

            if (($a.info.type == Type.INT) && ($c.info.type == Type.INT)) {
                genCode("%t" + variableCount + " = sub nsw i32 %t" + $info.value.index + ", %t" + $c.info.value.index);
                // Update arithmeticExpression's info.
                flag = true;
            }
            else if (($a.info.type == Type.INT) && ($c.info.type == Type.INT_CONST)) {
                genCode("%t" + variableCount + " = sub nsw i32 %t" + $info.value.index + ", " + $c.info.value.intValue);
                // Update arithmeticExpression's info.
                flag = true;
            }
            else if (($a.info.type == Type.INT_CONST) && ($c.info.type == Type.INT)) {
                genCode("%t" + variableCount + " = sub nsw i32 " + $info.value.intValue + ", %t" + $c.info.value.index);
                // Update arithmeticExpression's info.
                flag = true;
            }
            else if (($a.info.type == Type.INT_CONST) && ($c.info.type == Type.INT_CONST)) {
                genCode("%t" + variableCount + " = sub nsw i32 " + $info.value.intValue + ", " + $c.info.value.intValue);
                // Update arithmeticExpression's info.
                flag = true;
            }

            if(flag){
                $info.setType(Type.INT);
                $info.value.index = variableCount;
                variableCount ++;
            }
       }
   )*
   ;

multiplyExpression returns [Info info] @init {$info = new Info();}
   : a=signExpression { $info=$a.info; }
   ( '*' b=signExpression
       {
            boolean flag = false;

            if (($a.info.type == Type.INT) && ($b.info.type == Type.INT)) {
                genCode("%t" + variableCount + " = mul nsw i32 %t" + $info.value.index + ", %t" + $b.info.value.index);
                // Update arithmeticExpression's info.
                flag = true;
            }
            else if (($a.info.type == Type.INT) && ($b.info.type == Type.INT_CONST)) {
                genCode("%t" + variableCount + " = mul nsw i32 %t" + $info.value.index + ", " + $b.info.value.intValue);
                flag = true;
            }
            else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT)) {
                genCode("%t" + variableCount + " = mul nsw i32 " + $info.value.intValue + ", %t" + $b.info.value.index);
                flag = true;
            }
            else if (($a.info.type == Type.INT_CONST) && ($b.info.type == Type.INT_CONST)) {
                genCode("%t" + variableCount + " = mul nsw i32 " + $info.value.intValue + ", " + $b.info.value.intValue);
                flag = true;
            }

            if(flag){
                $info.setType(Type.INT);
                $info.value.index = variableCount;
                variableCount ++;
            }

       }
   | '/' c=signExpression
       {
            boolean flag = false;
            if (($a.info.type == Type.INT) && ($c.info.type == Type.INT)) {
                genCode("%t" + variableCount + " = sdiv i32 %t" + $info.value.index + ", %t" + $c.info.value.index);
                flag = true;
            }
            else if (($a.info.type == Type.INT) && ($c.info.type == Type.INT_CONST)) {
                genCode("%t" + variableCount + " = sdiv i32 %t" + $info.value.index + ", " + $c.info.value.intValue);
                flag = true;
            }
            else if (($a.info.type == Type.INT_CONST) && ($c.info.type == Type.INT)) {
                genCode("%t" + variableCount + " = sdiv i32 " + $info.value.intValue + ", %t" + $c.info.value.index);
                flag = true;
            }
            else if (($a.info.type == Type.INT_CONST) && ($c.info.type == Type.INT_CONST)) {
                genCode("%t" + variableCount + " = sdiv i32 " + $info.value.intValue + ", " + $c.info.value.intValue);
                flag = true;
            }

            if(flag){
                $info.setType(Type.INT);
                $info.value.index = variableCount;
                variableCount ++;
            }

       }
   )*
   ;

signExpression returns [Info info] @init {$info = new Info();}
   : a=primaryExpression { $info=$a.info; }
   | '-' b=primaryExpression
        {
              if($b.info.type == Type.INT_CONST || $b.info.type == Type.INT){
                String code1 = "%t" + variableCount + " = sub nsw i32 " + 0;
                String code2 = "";
                if($b.info.type == Type.INT)code2 = ", %t" + $b.info.value.index;
                if($b.info.type == Type.INT_CONST)code2 = ", " + $b.info.value.intValue;
                String code = code1 + code2;
                genCode(code);


                $info.setType(Type.INT);
                $info.value.index = variableCount;
                variableCount ++;

              }
        }
    ;

primaryExpression returns [Info info] @init {$info = new Info();}
   : INT_VALUE
       {
          $info.setType(Type.INT_CONST);
          $info.value.intValue = Integer.parseInt($INT_VALUE.text);
       }
   | FLOAT_VALUE
       {
          $info.setType(Type.FLOAT_CONST);
          $info.value.floatValue = Float.parseFloat($FLOAT_VALUE.text);
       }
   | ID
        {
            Type type = symbolTable.get($ID.text).type;
            $info.setType(type);
            int index = symbolTable.get($ID.text).value.index;

            switch (type) {
                case INT:
                    genCode("%t" + variableCount + " = load i32, i32* %t" + index);
                    $info.value.index = variableCount;
                    variableCount ++;
                    break;
                case FLOAT:
                    genCode("%t" + variableCount + " = load float, float* %t" + index + ", align 4");
                    $info.value.index = variableCount;
                    variableCount ++;
                    break;
                case CHAR:
                    break;
                default: break;
            }
        }
   | '&' ID
   | '(' arithmeticExpression
        {$info = $arithmeticExpression.info;}
    ')'
   ;



// Macro
INCLUDE         : 'include' (' ')* '<'ID '.h' (' ')* '>';
DEFINE          : 'define';
IFDEF           : 'ifdef';
IFNDEF          : 'ifndef';
ENDIF           : 'endif';
UNDEF           : 'undef';
MACRO           : '#' (INCLUDE | DEFINE | IFDEF | IFNDEF | ENDIF | UNDEF) -> skip;


/* description of the tokens */
FLOAT : 'float';
INT   : 'int';
CHAR  : 'char';

MAIN  : 'main';
VOID  : 'void';

IF    : 'if';
ELSE  : 'else';

FOR   : 'for';
WHILE : 'while';

//switch 沒有用到
SWITCH: 'switch';
BREAK : 'break';
CASE  : 'case';
DEFAULT: 'default';

RETURN: 'return';

//INCREASEMENT: '++';
//DECREASEMENT: '--';


ID : LETTER (LETTER | DIGIT)*;
INT_VALUE: DIGIT+;
FLOAT_VALUE: FLOAT_VALUE1 | FLOAT_VALUE2 ;

STRING_VALUE
   :  '"' ( ESC | ~('\\'|'"') )* '"'
   ;

WS:( ' ' | '\t' | '\r' | '\n' ) -> skip;
COMMENT:'/*' (.)*? '*/' -> skip;

//==================================Fragments==================================

//basic
fragment DIGIT  : '0'..'9';
fragment LETTER : [a-zA-Z_];
fragment ESC    : '\\' .;

// Floating point literals
fragment FLOAT_VALUE1 : DIGIT+ '.' DIGIT*;
fragment FLOAT_VALUE2 : '.' DIGIT+;
fragment FLOAT_VALUE3 : DIGIT+;




