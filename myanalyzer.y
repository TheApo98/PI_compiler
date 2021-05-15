%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "cgen.h"

    // #define YYSTYPE const char*

    extern int yylex(void);
    extern int lineNum;
%}

%union{
    char* string;
}

/* Keywords */
%token KEYWORD_INT   
%token KEYWORD_REAL   
%token KEYWORD_STRING  
%token KEYWORD_BOOL   
%token KEYWORD_TRUE   
%token KEYWORD_FALSE  
%token KEYWORD_VAR   
%token KEYWORD_CONST  
%token KEYWORD_IF   
%token KEYWORD_ELSE   
%token KEYWORD_FOR   
%token KEYWORD_WHILE  
%token KEYWORD_BREAK  
%token KEYWORD_CONTINUE
%token KEYWORD_FUNC   
%token KEYWORD_NIL   
%token KEYWORD_RETURN  
%token KEYWORD_BEGIN  

/* Operators */
%token ASSIGN_OP   
%left OR_LOGIC_OP  
%left AND_LOGIC_OP  

%left ( LESS_OP    
        GREATER_OP   
        LESS_EQ_OP   
        GREATER_EQ_OP  
        EQUALS_OP   
        NOT_EQUALS_OP ) 

%left PLUS_OP MINUS_OP    
%left MULT_OP DIV_OP MOD_OP     
%right POWER_OP    
/* sign_op */
%right NOT_LOGIC_OP  

/* Delimiters */
%token SEMICOLON   
%token L_PARENTHESIS  
%token R_PARENTHESIS  
%token COMMA     
%token L_BRACKET   
%token R_BRACKET   
%token L_CURLY_BRACKET
%token R_CURLY_BRACKET

%token <string> CONST_STRING
%token <string> INTEGER  
%token <string> REAL             
%token <string> IDENTIFIER  

/* Special functions */
%token RS_FUNC
%token RI_FUNC
%token RR_FUNC
%token WS_FUNC
%token WI_FUNC
%token WR_FUNC

/* Non-terminal symbols */
%type <string> program data_type expr statement

/* Rules */
%%

program: 
;

expr: IDENTIFIER    { $$ = $1 } 
    | INTEGER       { $$ = $1 }
    | REAL          { $$ = $1 }
    | MINUS_OP expr         { $$ = template("-%s", $2) }    //not sure
    | L_PARENTHESIS expr R_PARENTHESIS  { $$ = template("(%s)", $2) }
    | expr PLUS_OP expr     { $$ = template("%s + %s", $1, $3) }
    | expr MINUS_OP expr    { $$ = template("%s - %s", $1, $3) }
    | expr MULT_OP expr     { $$ = template("%s * %s", $1, $3) }
    | expr DIV_OP expr      { $$ = template("%s / %s", $1, $3) }
    | expr MOD_OP expr      { $$ = template("%s \% %s", $1, $3) }
    | expr POWER_OP expr    { $$ = template("%s ** %s", $1, $3) }
    | expr POWER_OP expr    { $$ = template("%s ** %s", $1, $3) }
    | expr L_BRACKET expr R_BRACKET { $$ = template("%s[%s]", $1, $3) }
    /* func call */
    | NOT_LOGIC_OP expr         { $$ = template("!%s", $2) }
    | expr AND_LOGIC_OP expr    { $$ = template("%s && %s", $1, $3) }
    | expr OR_LOGIC_OP expr     { $$ = template("%s || %s", $1, $3) }
    | expr EQUALS_OP expr       { $$ = template("%s == %s", $1, $3) }
    | expr NOT_EQUALS_OP expr   { $$ = template("%s != %s", $1, $3) }
    | expr GREATER_EQ_OP expr   { $$ = template("%s >= %s", $1, $3) }
    | expr LESS_EQ_OP expr      { $$ = template("%s <= %s", $1, $3) }
    | expr GREATER_OP expr      { $$ = template("%s > %s", $1, $3) }
    | expr LESS_OP expr         { $$ = template("%s < %s", $1, $3) }
;

data_type: KEYWORD_INT      { $$ = $1 }
         | KEYWORD_REAL     { $$ = $1 }
         | KEYWORD_STRING   { $$ = $1 }
         | KEYWORD_BOOL     { $$ = $1 }
         | L_BRACKET expr R_BRACKET data_type   { $$ = template("[%s] %s", $2, $4) }    //not sure
         | L_BRACKET R_BRACKET data_type        { $$ = template("[%s] %s", $2, $4) }
;

variable: KEYWORD_VAR IDENTIFIER data_type SEMICOLON
        | 
;

statement: L_CURLY_BRACKET statement R_CURLY_BRACKET
          | KEYWORD_IF L_PARENTHESIS expr R_PARENTHESIS statement
          | KEYWORD_WHILE L_PARENTHESIS expr R_PARENTHESIS statement
          | KEYWORD_RETURN expr SEMICOLON
;




%%
int main() {
    if (yyparse() == 0)
        printf("Accepted\n");
    else
        printf("Rejected\n");
}
