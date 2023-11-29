grammar Macros;

/*
 * Parser Rules
 */

entries : (NEWLINE*? entry NEWLINE*?)* ;
entry : definition id_line? (write_line | call_line | if_block)*? end;
definition : WHITESPACE*? MACRO WHITESPACE NAME (WHITESPACE argument_definition)* (WHITESPACE last_argument_definition)? NEWLINE?;
last_argument_definition : NAME ('=' number_or_argument)? NEWLINE ;
argument_definition : NAME ('=' number_or_argument)? ',' ;

id_line : WHITESPACE*? SHORT WHITESPACE NUMBER NEWLINE ;

write_line : WHITESPACE*? write NEWLINE;
call_line : WHITESPACE*? NAME WHITESPACE*? (WHITESPACE (input_2 ','))* (WHITESPACE (input_2 NEWLINE))? ;
else_line : WHITESPACE*? ELSE NEWLINE ;
if_line : WHITESPACE*? IF WHITESPACE*? compare NEWLINE ;
endif_line : WHITESPACE*? ENDIF NEWLINE ;

if_block : if_line (write_line | call_line | if_block)*? (else_block | endif_line) ;
else_block : else_line (write_line | call_line | if_block)*? endif_line ;

end : WHITESPACE*? END_MACRO NEWLINE?? ;

write : (BYTE | SHORT | WORD) WHITESPACE input_2 ;

number_or_argument : (ARGUMENT_USAGE | NUMBER | CURRENT_OFFSET | NAME) ;
bare_input : algebra | number_or_argument ;
input_2 : ('(' input_2 ')' | bare_input ) ;
wrapped_input : (number_or_argument | '(' algebra ')') ;

//comparator
algebra : algebra WHITESPACE*? ALGEBRAIC_OPERATOR WHITESPACE*? algebra | number_or_argument ;

bare_compare : bare_compare WHITESPACE*? COMPARATOR WHITESPACE*? bare_compare
             | bare_compare WHITESPACE*? AND_OR WHITESPACE*? bare_compare
             | number_or_argument ;

compare : ('(' compare ')' | bare_compare ) ;

/*
 * Lexer Rules
 */

fragment DIGIT : [0-9] ;
fragment HEX_DIGIT : (DIGIT | [a-fA-F]) ;
fragment LETTER : [a-zA-Z] ;

NUMBER : (DIGIT+ | '0x' HEX_DIGIT)+ ;

WHITESPACE : (' ' | '\t') ;
NEWLINE : ('\r'? '\n' | '\r')+ ;

NAME : (LETTER | NUMBER | '_')+ ;

MACRO : '.macro' ;
END_MACRO : '.endm' ;
IF : '.if' ;
ENDIF : '.endif' ;
ELSE : '.else' ;
BYTE : '.byte' ;
SHORT : '.short' ;
WORD : '.word' ;

ARGUMENT_USAGE : '\\' NAME ;

fragment GREATER_THAN : '>' ;
fragment LESS_THAN : '<' ;
fragment GREATER_THAN_OR_EQUAL_TO : '>=' ;
fragment LESS_THAN_OR_EQUAL_TO : '<=' ;
fragment EQUAL_TO : '==' ;
fragment NOT_EQUAL_TO : '!=' ;

fragment AND : '&&' ;
fragment OR : '||' ;

AND_OR : (AND | OR) ;

COMPARATOR : (GREATER_THAN | LESS_THAN | GREATER_THAN_OR_EQUAL_TO | LESS_THAN_OR_EQUAL_TO | EQUAL_TO | NOT_EQUAL_TO ) ;

fragment ADD : '+' ;
fragment SUBSTRACT : '-' ;
fragment MULTIPLY : '*' ;
fragment DIVIDE : '/' ;

ALGEBRAIC_OPERATOR : (ADD | SUBSTRACT | MULTIPLY | DIVIDE) ;

CURRENT_OFFSET : '.' ;

fragment COMMENT_CHARACTER : ';' ;

COMMENT : WHITESPACE*? COMMENT_CHARACTER WHITESPACE*? .*? NEWLINE -> skip ;