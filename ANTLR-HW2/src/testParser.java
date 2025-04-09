
import org.antlr.v4.runtime.*;

import java.io.IOException;

public class testParser {
    public static void main(String[] args) throws IOException {
        CharStream fileInput = CharStreams.fromFileName(args[0]);
        myparserLexer lexer = new myparserLexer(fileInput);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        myparserParser parser = new myparserParser(tokens);
        parser.program();
    }
}