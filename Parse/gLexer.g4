lexer grammar gLexer;

@header {
   package Parse.antlr_build;
}

tokens { STRING_LITERAL }

@members {
   StringBuilder sb;


   private int stringToInt(String target) {
      if (target.startsWith("0x") || target.startsWith("0X")) { // Hex
         return Integer.parseInt(target.substring(2), 16);
      } else if (target.startsWith("0") && target.length() > 1) { // Octal
         return Integer.parseInt(target, 8);
      } else { // Decimal
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

// ===== KEYWORDS =====
VAR     : 'var';
FUN     : 'fun';
WHILE   : 'while';
CONST   : 'const';
STRING  : 'string';
VOID    : 'void';
RETURN  : 'return';
IF      : 'if';
ELSE    : 'else';
BREAK   : 'break';
INT     : 'int';
TYPEDEF : 'typedef';
STRUCT  : 'struct';
UNION   : 'union';

// ===== IDENTIFIERS =====
ID
   : (ALPHA | '_') (ALPHA | DIGIT | '_')*
   ;

// ===== OPERATORS =====
AND   : '&&';
OR    : '||';
ARROW : '->';

LT     : '<';
MUL    : '*';
ADD    : '+';
TILDE  : '~';
ASSIGN : '=';
DOT    : '.';

// ===== PUNCTUATORS =====
LCURLY    : '{';
RCURLY    : '}';
COMMA     : ',';
LPAREN    : '(';
RPAREN    : ')';
BITWISEAND: '&';
BITWISEOR : '|';
NOT       : '!';
SEMI      : ';';
COLON     : ':';
LSQUARE   : '[';
RSQUARE   : ']';

// ===== INTEGERS =====
DECIMAL_LITERAL
   : '0' [xX] [0-9a-fA-F]+
   | '0' [0-7]+
   | '0'
   | [1-9] DIGIT*
   ;

// ===== COMMENTS =====
LINE_COMMENT  : '//' ~[\r\n]* -> skip;
BLOCK_COMMENT : '/*' .*? '*/' -> skip;

// ===== WHITESPACE =====
WS : [ \t\r\n]+ -> skip;

// ===== STRINGS =====
STRING_START
   : '"' { sb = new StringBuilder(); }
     -> pushMode(STRING_MODE), skip
   ;  

mode STRING_MODE;

<<<<<<< Updated upstream
  fragment ESC_SEQ
  : '\\' [btnrfav"'\\]
  |'\\' [0-7] [0-7]? [0-7]?
  | '\\' 'x' [0-9a-fA-F]+
  ;
   
=======
STRING_END
   : '"' { setText(sb.toString()); } -> type(STRING_LITERAL), popMode
   ;

STRING_CHAR
   : ~["\\\r\n] { sb.append(getText()); } -> skip
   ;

ESC_SIMPLE
   : '\\' [btnrfav"'\\]
     {
        switch(getText().charAt(1)) {
           case 'b': sb.append('\b'); break;
           case 't': sb.append('\t'); break;
           case 'n': sb.append('\n'); break;
           case 'r': sb.append('\r'); break;
           case 'f': sb.append('\f'); break;
           case 'a': sb.append('\u0007'); break;
           case 'v': sb.append('\u000B'); break;
           case '"': sb.append('"'); break;
           case '\'': sb.append('\''); break;
           case '\\': sb.append('\\'); break;
        }
     } -> skip
   ;

ESC_OCT
   : '\\' [0-7] { sb.append((char)Integer.parseInt(getText().substring(1),8)); } -> skip
   ;

ESC_HEX
   : '\\x' [0-9a-fA-F][0-9a-fA-F] { sb.append((char)Integer.parseInt(getText().substring(2),16)); } -> skip
   ;

BAD_STRING_ESCAPE
   : '\\' . -> skip
   ;

STRING_NEWLINE
   : [\r\n]
   ;
>>>>>>> Stashed changes
