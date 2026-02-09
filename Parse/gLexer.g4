lexer grammar gLexer;

@header {
   package Parse.antlr_build;
}


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
MUL     : '*'   ;  // Multiply
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
SEMI    : ';'   ;  // Semicolon
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

// ===== STRINGS =====
// Person 4
// ===== WHITESPACE =====
WS
  : [ \t\r\n]+ -> skip
  ;
// ===== COMMENTS =====
LINE_COMMENT
  : '//' ~[\r\n]* -> skip
  ;

BLOCK_COMMENT
  : '/*' .*? '*/' -> skip
  ;

  STRING_LITERAL
  : '"' (ESC_SEQ | ~["\\\r\n])* '"'
  ;

  // ==== ESCAPE SEQUENCES ====

  fragment ESC_SEQ
  : '\\' [btnrfav"'\\]
  |'\\' [0-7] [0-7]? [0-7]?
  | '\\' 'x' [0-9a-fA-F]+
  ;
