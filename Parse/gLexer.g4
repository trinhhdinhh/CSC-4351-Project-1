
lexer grammar gLexer;

@header {
   package Parse.antlr_build;
}


@members {
   StringBuilder sb;
   private int stringToInt(String target) {
      // TODO: Implement me!
      return 0;
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
LAND    : '&&'  ;  // Logical AND
LOR     : '||'  ;  // Logical OR
ARROW   : '->'  ;  // Arrow operator

// Single-character operators
LT      : '<'   ;  // Less than
MUL     : '*'   ;  // Multiply
ADD     : '+'   ;  // Add
BNOT    : '~'   ;  // Bitwise NOT
ASSIGN  : '='   ;  // Assignment
DOT     : '.'   ;  // Dot operator

// ===== PUNCTUATORS =====
// Person 2: All punctuators
LBRACE  : '{'   ;  // Left brace
RBRACE  : '}'   ;  // Right brace
COMMA   : ','   ;  // Comma
LPAREN  : '('   ;  // Left parenthesis
RPAREN  : ')'   ;  // Right parenthesis
BAND    : '&'   ;  // Bitwise AND / Address-of
BOR     : '|'   ;  // Bitwise OR
LNOT    : '!'   ;  // Logical NOT
SEMI    : ';'   ;  // Semicolon
COLON   : ':'   ;  // Colon
LBRACK  : '['   ;  // Left bracket
RBRACK  : ']'   ;  // Right bracket
