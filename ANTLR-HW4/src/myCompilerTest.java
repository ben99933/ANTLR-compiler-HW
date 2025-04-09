import org.antlr.v4.runtime.*;

import java.io.IOException;
import java.util.List;


public class myCompilerTest {
    public static void main(String[] args) throws IOException {
        CharStream input = CharStreams.fromFileName(args[0]);
        myCompilerLexer lexer = new myCompilerLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);

        myCompilerParser parser = new myCompilerParser(tokens);
        parser.program();

        /* Output text section */
        List<String> text_code = parser.textCode;

        for (int i=0; i < text_code.size(); i++)System.out.println(text_code.get(i));

    }
}
