 
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#define buffer_size 256
	#define table_size 200
    #define scope_size 10
	void yyerror();
	int yylex(void);
	int yylineno;
	
	unsigned id_exist = 0;
	unsigned flag = 0;
	char table[scope_size][table_size][buffer_size];
	int lookup(char *s);
	int insert(char *s);

	int scope_num = 0;
	int idCount[scope_size] = {0};
	extern unsigned charCount;
	extern unsigned lineCount;
	extern char *yytext;
	char *temp_text;
	unsigned temp_charCount;
	int site = 0;
%}

%union{
	char* string;
}
%token INT FLOAT CHAR BOOLEAN STRING VOID
%token INT_VALUE FLOAT_VALUE CHAR_VALUE STRING_VALUE
%token<string> ID 
%token REL_OP
%token PLUS MINUS MUL DIV 

%right ASSIGN
%left  PLUS MINUS
%left  MUL DIV
%nonassoc UMINUS

%token SEMI COMMA DOT
%token STATIC NEW FINAL CLASS MAIN WHILE RETURN IF ELSE FOR PRINT READ
%token LT GT LE GE EQ NE AND OR PLUSPLUS MINUSMINUS
%token LP RP LBRACKET RBRACKET LBRACE RBRACE
%start debug

%%

debug : 
	| debug declare {
			if(flag == 1) yyerror();
            if(id_exist) {
                printf("\n> '%s' is a duplicate identifier.", table[scope_num][site]);
                id_exist = 0;
            }
			yyerrok;
		}
	| debug class_declare{
			if(flag == 1) {yyerror();}
            if(id_exist) {
                printf("\n> '%s' is a duplicate identifier.", table[scope_num][site]);
                id_exist = 0;
            }
			yyerrok;
		}
	| debug normal_declare {if(flag == 1) {yyerror();yyerrok;}}
	| debug array_declare {if(flag == 1) {yyerror();yyerrok;}}
	| debug identifier_list {if(flag == 1) {yyerror();yyerrok;}}
	| debug ID_check {if(flag == 1) {yyerror();yyerrok;}}
	| debug type {if(flag == 1) {yyerror();yyerrok;}}
	| debug final_declare {if(flag == 1) {yyerror();yyerrok;}}
	| debug f_declare {if(flag == 1) {yyerror();yyerrok;}}
	| debug method {if(flag == 1) {yyerror();yyerrok;}}
	| debug object {if(flag == 1) {yyerror();yyerrok;}}
	| debug compound {if(flag == 1) {yyerror();yyerrok;}}
	| debug in_compound {if(flag == 1) {yyerror();yyerrok;}}
	| debug one_simple {if(flag == 1) {yyerror();yyerrok;}}
	| debug simple {if(flag == 1) {yyerror();yyerrok;}}
	| debug name {if(flag == 1) {yyerror();yyerrok;}}
	| debug expr {if(flag == 1) {yyerror();yyerrok;}}
	| debug term {if(flag == 1) {yyerror();yyerrok;}}
	| debug factor {if(flag == 1) {yyerror();yyerrok;}}
	| debug const_expr {if(flag == 1) {yyerror();yyerrok;}}
	| debug preFixOp {if(flag == 1) {yyerror();yyerrok;}}
	| debug postFixOp {if(flag == 1) {yyerror();yyerrok;}}
	| debug methodInvocation {if(flag == 1) {yyerror();yyerrok;}}
	| debug method_arg {if(flag == 1) {yyerror();yyerrok;}}
	| debug conditional {if(flag == 1) {yyerror();yyerrok;}}
	| debug boolean_expr {if(flag == 1) {yyerror();yyerrok;}} 
	| debug infixOp {if(flag == 1) {yyerror();yyerrok;}}
	| debug whileLoop {if(flag == 1) {yyerror();yyerrok;}}
	| debug forLoop {if(flag == 1) {yyerror();yyerrok;}}
	| debug forInitOpt {if(flag == 1) {yyerror();yyerrok;}}
	| debug forUpdateOpt {if(flag == 1) {yyerror();yyerrok;}}
	| debug return {if(flag == 1) {yyerror();yyerrok;}}
	| debug main_func {if(flag == 1) {yyerror();yyerrok;}}
	| debug COMMA {if(flag == 1) {yyerror();yyerrok;}}
	| debug ELSE { 
			if(flag == 1) {
				yyerror();
				yyerrok;
			}
			if(scope_num && flag == 0) {
				flag = 1;
				temp_charCount = charCount;
				temp_text = strdup("else");
				yyerror();
				yyerrok;
			}
		}
	| debug SEMI{
			if(flag == 1) {
				flag =0; 
				printf("\nLine %d, need ';' at EOL ", lineCount);
        		yyerrok;
			}
		}
	| error { 
			if(flag == 0){
				temp_text = strdup(yytext);
				temp_charCount = charCount;
				flag = 1;
			}
		}
	;
declare : 
	  class_declare
	| normal_declare 
	| final_declare
	| method
	| main_func
	| whileLoop
	| conditional
	| forLoop
	| return
	| array_declare
	| object
	| declare class_declare
	| declare normal_declare 
	| declare final_declare
	| declare method
	| declare main_func
	| declare whileLoop
	| declare conditional
	| declare forLoop
	| declare return
	| declare array_declare
	| declare object
	;

class_declare : 
	CLASS ID_check LBRACE_update declare RBRACE_update;

normal_declare : 
	type identifier_list SEMI
	| STATIC type identifier_list SEMI
	;

array_declare : 
	type LBRACKET RBRACKET ID_check ASSIGN NEW type LBRACKET INT_VALUE RBRACKET SEMI;

identifier_list : 
	ID_check 
	| ID_check ASSIGN expr
	| identifier_list COMMA ID_check
	| identifier_list COMMA ID_check ASSIGN expr
	| identifier_list COMMA type ID_check
	| identifier_list COMMA type ID_check ASSIGN expr
	| identifier_list error ID { yyerror(); yyerrok; }
	;

ID_check : ID { 
			id_exist = insert($1); 
			if( id_exist == -1 ){
				printf("\n>Line %d : duplicate identifier \"%s\"",lineCount,$1);
			}
			id_exist = 0;
		}
	;
type : 
	  type LBRACKET RBRACKET 
	| type LBRACKET expr RBRACKET
	| INT | FLOAT | CHAR 
	| BOOLEAN | STRING | ID | VOID
	;

final_declare : FINAL type f_declare SEMI
	;

f_declare : 
	ID_check ASSIGN expr 
	| f_declare COMMA ID_check ASSIGN expr
	;

method : 
	  type ID_check LP RP compound
	| type ID_check LP type identifier_list RP compound 
	;

object : 
	  ID ID_check ASSIGN NEW ID LP RP SEMI
	;

compound : LBRACE_update in_compound RBRACE_update
	;

in_compound : 
	  object  
	| normal_declare 
	| simple 
	| method
	| whileLoop
	| conditional
	| forLoop
	| return
	| array_declare
	| compound
	| in_compound object
	| in_compound normal_declare 
	| in_compound method
	| in_compound whileLoop
	| in_compound conditional
	| in_compound forLoop
	| in_compound return
	| in_compound simple
	| in_compound array_declare
	| in_compound compound
	;

one_simple : 
	 name ASSIGN expr SEMI 	/* a=5; */
	| PRINT LP expr RP SEMI		
	| READ LP name RP SEMI
	| name PLUSPLUS SEMI
	| name MINUSMINUS SEMI
	| expr SEMI
	;
simple : 
	  one_simple 
	| simple one_simple
	;

name : 
	  ID 
	| ID DOT ID 
	| ID LBRACKET expr RBRACKET
	;

expr : 
	  term 
	| expr PLUS term 
	| expr MINUS term
	;
term : 
	  factor 
	| term MUL factor 
	| term DIV factor
	;
factor : 
	  ID 
	| ID LBRACKET expr RBRACKET
	| const_expr 
	| LP expr RP 
	| preFixOp ID 
	| ID postFixOp 
	| methodInvocation
	;
const_expr : INT_VALUE | FLOAT_VALUE ;
preFixOp : PLUSPLUS | MINUSMINUS | PLUS | MINUS ;
postFixOp : PLUSPLUS | MINUSMINUS ;

methodInvocation : name LP method_arg RP SEMI;
method_arg : expr | method_arg COMMA expr;

conditional : 
	  IF LP boolean_expr RP simple
	| IF LP boolean_expr RP compound
	| IF LP boolean_expr RP simple ELSE simple
	| IF LP boolean_expr RP simple ELSE compound
	| IF LP boolean_expr RP compound ELSE simple
	| IF LP boolean_expr RP compound ELSE compound
	;
boolean_expr : expr infixOp expr;
infixOp : EQ | NE | LT | GT | LE | GE ;

whileLoop : WHILE LP boolean_expr RP simple
	| WHILE LP boolean_expr RP compound
	;
forLoop : 
	  FOR LP forInitOpt SEMI boolean_expr SEMI forUpdateOpt RP compound
	| FOR LP forInitOpt SEMI boolean_expr SEMI forUpdateOpt RP one_simple
	;
forInitOpt : 
	  ID ASSIGN expr
	| INT ID ASSIGN expr
	| ID LBRACKET expr RBRACKET ASSIGN expr
	| INT ID LBRACKET expr RBRACKET ASSIGN expr
	| forInitOpt ID ASSIGN expr
	| forInitOpt INT ID ASSIGN expr
	| forInitOpt ID LBRACKET expr RBRACKET ASSIGN expr
	| forInitOpt INT ID LBRACKET expr RBRACKET ASSIGN expr
	;
forUpdateOpt :
	  ID PLUSPLUS
	| ID MINUSMINUS
	| ID LBRACKET expr RBRACKET PLUSPLUS
	| ID LBRACKET expr RBRACKET MINUSMINUS
	;
return : RETURN expr SEMI;

main_func : 
	MAIN LP RP compound
	| VOID MAIN LP RP compound
	| INT MAIN LP RP compound
	;

LBRACE_update : LBRACE { scope_num++; }
RBRACE_update : RBRACE { scope_num--; }

%%

void yyerror(){
	if(flag == 1) 
	{
	    printf("\nLine %d, 1st char: %d, error at \"%s\"", lineCount , temp_charCount, temp_text);
        flag = 0;
    }
}

int lookup(char *s){
    int i;
    for(i=0;i<idCount[scope_num];i++){
        if(strcmp(table[scope_num][i],s) == 0){
			site = i;
            return i;
        }
    }
    return -1;
}

int insert(char *s){
	if(lookup(s) == -1){
		strcpy(table[scope_num][idCount[scope_num]],s);
        return idCount[scope_num]++;
	}
    return -1; 
}

int main(){
	yyparse();
	return 0;
}
