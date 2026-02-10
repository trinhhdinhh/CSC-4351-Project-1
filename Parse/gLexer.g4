lexer grammar gLexer;

@header {
   package Parse.antlr_build;
}

tokens { STRING_LITERAL }

@members {
   StringBuilder sb;
   private int stringToInt(String target) {
      
      if (target.startsWith("0x") || target.startsWith("0X")) { //Hex, substring from 2 on to skip "0x"
         return Integer.parseInt(target.substring(2), 16);
      }
      else if (target.startsWith("0") && target.length() > 1) { //Octal, can just parse entire integer 
         return Integer.parseInt(target, 8);
      } 
      else { // Decimal
         return Integer.parseInt(target, 10);
      }
   }

}

fragment ALPHA
   : [A-Za-z]
   ;
fragment DIGIT
   : [0-9]
   ;

// ===== KEYWORDS (must come before ID) =====
// Person 1: Keywords must be defined before ID to ensure proper matching
VAR     : 'var'     ;
FUN     : 'fun'     ;
WHILE   : 'while'   ;
CONST   : 'const'   ;
STRING  : 'string'  ;
VOID    : 'void'    ;
RETURN  : 'return'  ;
IF      : 'if'      ;
ELSE    : 'else'    ;
BREAK   : 'break'   ;
INT     : 'int'     ;
TYPEDEF : 'typedef' ;
STRUCT  : 'struct'  ;
UNION   : 'union'   ;

// ===== IDENTIFIER (must come after keywords) =====
// Person 1: ID follows C spec - starts with letter/underscore, followed by alphanumeric/underscore
ID
   : (ALPHA | '_') (ALPHA | DIGIT | '_')*
   ;

// ===== OPERATORS =====
// Person 2: Multi-character operators MUST come before single-character ones

// Multi-character operators
AND    : '&&'  ;  // Logical AND
OR     : '||'  ;  // Logical OR
ARROW   : '->'  ;  // Arrow operator

// Single-character operators
LT      : '<'   ;  // Less than
STAR     : '*'   ;  // Multiply
ADD     : '+'   ;  // Add
TILDE    : '~'   ;  // Bitwise NOT
ASSIGN  : '='   ;  // Assignment
DOT     : '.'   ;  // Dot operator

// ===== PUNCTUATORS =====
// Person 2: All punctuators
LCURLY  : '{'   ;  // Left brace
RCURLY  : '}'   ;  // Right brace
COMMA   : ','   ;  // Comma
LPAREN  : '('   ;  // Left parenthesis
RPAREN  : ')'   ;  // Right parenthesis
BITWISEAND    : '&'   ;  // Bitwise AND / Address-of
BITWISEOR     : '|'   ;  // Bitwise OR
NOT    : '!'   ;  // Logical NOT
SEMICOLON    : ';'   ;  // Semicolon
COLON   : ':'   ;  // Colon
LSQUARE  : '['   ;  // Left bracket
RSQUARE  : ']'   ;  // Right bracket

// ===== INTEGERS =====
// Person 3
DECIMAL_LITERAL
   : '0' [xX] [0-9a-fA-F]+      // Hex -> 0x(Digit between 0-9,a-f,A-F) repeated at least once
   | '0' [0-7]+                  // Octal -> 0(Digit between 0-7) repeated at least once
   | '0'                         // Single digit zero
   | [1-9] DIGIT*                // Decimal -> (Digit between 1-9) (Digit fragment defined earlier, that is digit between 0-9) repeated 0 or more times
   ;

// ===== COMMENTS =====
// Person 4
LINE_COMMENT  : '//' ~[\r\n]* -> skip; //Single Line
BLOCK_COMMENT : '/*' .*? '*/' -> skip; //Block Comments (Get Skipped)

// ===== WHITESPACE =====
WS : [ \t\r\n]+ -> skip; //Skips tabs, spaces, and newlines

// ===== STRINGS =====
STRING_START // Entry point for string literals
   : '"' { sb = new StringBuilder(); } //Initialize string builder
     -> pushMode(STRING_MODE), skip
   ; 

mode STRING_MODE; //Switch to string mode

STRING_END //End of string
   : '"' { setText(sb.toString()); } -> type(STRING_LITERAL), popMode
   ;

STRING_CHAR //Regular characters inside string (not backslashes or quotes)
   : ~["\\\r\n] { sb.append(getText()); } -> skip
   ;

ESC_SIMPLE //Simple escapes (\n \t)
   : '\\' [btnrfav"'\\?]
     {
        switch(getText().charAt(1)) {
           case 'b': sb.append('\b'); break;
           case 't': sb.append('\t'); break;
           case 'n': sb.append('\n'); break;
           case 'r': sb.append('\r'); break;
           case 'f': sb.append('\f'); break;
           case 'a': sb.append('\u0007'); break;
           case 'v': sb.append('\u000B'); break;
           case '"': sb.append("\\\""); break;
           case '\'': sb.append('\''); break;
           case '\\': sb.append("\\"); break;
           case '?': sb.append("?"); break;
        }
     } -> skip
   ;

ESC_OCT //Octal escapes (\0 - \377)
   : '\\' ( [0-3] [0-7] [0-7]  // Three digits: \000 - \377
          | [0-7] [0-7]         // Two digits: \00 - \77
          | [0-7]               // One digit: \0 - \7
          )
     { sb.append((char)Integer.parseInt(getText().substring(1), 8)); }
     -> skip
   ;

ESC_HEX //Hexadecimal escape sequences (\x0 - \xFF)
   : '\\x' ( [0-9a-fA-F] [0-9a-fA-F]  // Two hex digits
           | [0-9a-fA-F]               // One hex digit
           )
     { sb.append((char)Integer.parseInt(getText().substring(2), 16)); }
     -> skip
   ;

BAD_STRING_ESCAPE //Invalid escape sequences
   : '\\' . -> skip
   ;

STRING_NEWLINE // Newlines inside strings (optional: replace with "\\n" if needed)
   : [\r\n]
   ;
