package hw1;

import org.antlr.v4.runtime.*;

public class testLexer {
    public static void main(String[] args) {
        try{
            CharStream fileInput = CharStreams.fromFileName(args[0]);
            mylexer lexer = new mylexer(fileInput);
            CommonTokenStream tokens = new CommonTokenStream(lexer);

            // Print the tokens
            tokens.fill();
            for (Token token : tokens.getTokens()) {
                String tokenName = mylexer.VOCABULARY.getSymbolicName(token.getType());
                String tokenValue = token.getText();
                System.out.printf("Token: %s, Value: %s\n", tokenName, tokenValue);
            }

        }catch(Exception e){
            System.out.println("Error: " + e);
        }



    }
}
