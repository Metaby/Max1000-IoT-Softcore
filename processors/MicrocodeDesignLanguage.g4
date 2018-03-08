// Grammar and Entry
grammar MicrocodeDesignLanguage;
gr_mdf: gr_field_declaration* gr_init (gr_function | gr_virtual)*;

// Function
gr_function_head: 'function' gr_function_name '(' gr_function_pos ')' '{';
gr_function_name: gr_qualifier;
gr_function_pos: ('auto' | gr_hex) (',' gr_hex ',' gr_number)?;
gr_function_tail: '}';
gr_function_set: 'set' gr_function_set_code ';';
gr_function_set_code: (gr_field | ((gr_field ',')+ gr_field));
gr_function_call: 'call' gr_function_call_code ';';
gr_function_call_code: gr_qualifier '()';
gr_function_fix: 'fix' gr_function_fix_code ';';
gr_function_fix_code: (gr_field | ((gr_field ',')+ gr_field));
gr_function_body: (gr_function_set | gr_function_call | gr_function_fix)*;
gr_function: gr_function_head gr_function_body gr_function_tail;

// Virtual
gr_virtual_head: 'virtual' gr_function_name '()' '{';
gr_virtual: gr_virtual_head gr_function_body gr_function_tail;

// Init
gr_init_perm: 'perm' gr_init_perm_code ';';
gr_init_perm_code: (gr_field | ((gr_field ',')+ gr_field));
gr_init_head: 'init' '(' '0x00' ')' '{';
gr_init_body: (gr_function_set | gr_function_call | gr_function_fix | gr_init_perm)*;
gr_init: gr_init_head gr_init_body gr_function_tail;

// Qualifier and Fields
gr_qualifier: (gr_char | gr_digit | '_')+;
gr_field: gr_qualifier '(' gr_parameter ')';
gr_parameter: gr_qualifier '.' gr_qualifier | 'CONST(' gr_number ')' | gr_qualifier;
gr_lc_char: 'a' | 'b' | 'c' | 'd' | 'e' | 'f' | 'g' | 'h' | 'i' | 'j' | 'k' | 'l' | 'm' | 'n' | 'o' | 'p' | 'q' | 'r' | 's' | 't' | 'u' | 'v' | 'w' | 'x' | 'y' | 'z';
gr_uc_char: 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G' | 'H' | 'I' | 'J' | 'K' | 'L' | 'M' | 'N' | 'O' | 'P' | 'Q' | 'R' | 'S' | 'T' | 'U' | 'V' | 'W' | 'X' | 'Y' | 'Z';
gr_char: gr_lc_char | gr_uc_char;
gr_digit: '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9';
gr_number: gr_digit+;
gr_hex_digit: gr_digit | 'A' | 'B' | 'C' | 'D' | 'E' | 'F';
gr_hex: '0x' gr_hex_digit gr_hex_digit;

// Field-Imports
gr_field_declaration: 'field' gr_field_id '=' gr_field_positions gr_field_params gr_field_values ';';
gr_field_id: gr_qualifier;
gr_field_positions: '{' (gr_number ',' gr_number) '}';
gr_field_params: '{' (gr_parameter | ((gr_parameter ',')+ gr_parameter)) '}';
gr_field_values: '{' (gr_number | ((gr_number ',')+ gr_number)) '}';

// Ignore-Patterns
WHITES: [ \r\n\t]+ -> channel(HIDDEN);
S_COMMENT: '//' ~[\n\r]* -> channel(HIDDEN);
M_COMMENT: '/*' .*? '*/' -> channel(HIDDEN);