%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "helperFiles/cgen.h"

    // #define YYSTYPE const char*

    extern int yylex(void);
    extern int line_num;
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

%left LESS_OP    
%left GREATER_OP   
%left LESS_EQ_OP   
%left GREATER_EQ_OP  
%left EQUALS_OP   
%left NOT_EQUALS_OP 

%left PLUS_OP MINUS_OP    
%left MULT_OP DIV_OP MOD_OP     
%right POWER_OP    
/* sign_op */
%right NOT_LOGIC_OP  

/* Delimiters */
%token SEMICOLON   
%token L_PAREN  
%token R_PAREN  
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
%type <string> program data_type expr statement variable variable1 decl_list decl body
%type <string> expr1

/* The first symbol */
%start program

/* Rules */
%%

program: decl_list KEYWORD_FUNC KEYWORD_BEGIN 
         L_PAREN R_PAREN L_CURLY_BRACKET R_CURLY_BRACKET body  { 

 /* We have a successful parse! 
    Check for any errors and generate output. 
  */
  
  if (yyerror_count == 0) {
    // include the pilib.h file
    puts(c_prologue); 
    printf("/* program */ \n\n");
    printf("%s\n\n", $1);
    printf("int main() {\n%s\n} \n", $7);
  }
}
;

decl_list: decl_list decl   { $$ = template("%s\n%s", $1, $2); }
         | decl             { $$ = $1; }
;

/* Probably function declarations and global vars */
decl:  {$$="";}
;
 
/* Body of the main fucnction */
body: { $$="";}
;

expr: expr1                 { $$ = $1; } 
    | MINUS_OP expr         { $$ = template("-%s", $2); }    //not sure
    | L_PAREN expr R_PAREN  { $$ = template("(%s)", $2); }
    | expr1 PLUS_OP expr     { $$ = template("%s + %s", $1, $3); }
    | expr1 MINUS_OP expr    { $$ = template("%s - %s", $1, $3); }
    | expr1 MULT_OP expr     { $$ = template("%s * %s", $1, $3); }
    | expr1 DIV_OP expr      { $$ = template("%s / %s", $1, $3); }
    | expr1 MOD_OP expr      { $$ = template("%s \% %s", $1, $3); }
    | expr1 POWER_OP expr    { $$ = template("%s ** %s", $1, $3); }
    | expr1 L_BRACKET expr R_BRACKET { $$ = template("%s[%s]", $1, $3); }
    /* func call */
    | NOT_LOGIC_OP expr         { $$ = template("!%s", $2); }
    | expr1 AND_LOGIC_OP expr    { $$ = template("%s && %s", $1, $3); }
    | expr1 OR_LOGIC_OP expr     { $$ = template("%s || %s", $1, $3); }
    | expr1 EQUALS_OP expr       { $$ = template("%s == %s", $1, $3); }
    | expr1 NOT_EQUALS_OP expr   { $$ = template("%s != %s", $1, $3); }
    | expr1 GREATER_EQ_OP expr   { $$ = template("%s >= %s", $1, $3); }
    | expr1 LESS_EQ_OP expr      { $$ = template("%s <= %s", $1, $3); }
    | expr1 GREATER_OP expr      { $$ = template("%s > %s", $1, $3); }
    | expr1 LESS_OP expr         { $$ = template("%s < %s", $1, $3); }
;

expr1: IDENTIFIER    { $$ = $1; } 
     | INTEGER       { $$ = $1; }
     | REAL          { $$ = $1; } 
     /* | CONST_STRING          { $$ = $1; } */
;

data_type: KEYWORD_INT      { $$ = template("int"); }
         | KEYWORD_REAL     { $$ = template("double"); }
         | KEYWORD_STRING   { $$ = template("char*"); }
         | KEYWORD_BOOL     { $$ = template("int"); }
         | L_BRACKET expr R_BRACKET data_type   { $$ = template("[%s] %s", $2, $4); }    //not sure
         | L_BRACKET R_BRACKET data_type        { $$ = template("[] %s", $3); }
;

variable: KEYWORD_VAR variable1 data_type SEMICOLON {$$ = template("%s %s;", $3, $2);}
;

variable1: IDENTIFIER ASSIGN_OP expr    { $$ = template("%s = %s", $1, $3); }
         | IDENTIFIER                   { $$ = $1; }
         | variable1 COMMA variable1    { $$ = template("%s , %s", $1, $3); }
         /* | IDENTIFIER ASSIGN_OP CONST_STRING */
;

/* statement: L_CURLY_BRACKET statement R_CURLY_BRACKET
          | KEYWORD_IF L_PAREN expr R_PAREN statement
          | KEYWORD_WHILE L_PAREN expr R_PAREN statement
          | KEYWORD_RETURN expr SEMICOLON
; */




%%
int main() {
    if (yyparse() == 0)
        printf("Accepted\n");
    else
        printf("Rejected\n");
}
