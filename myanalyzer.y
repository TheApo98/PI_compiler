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
%token RS_FUNCT
%token RI_FUNCT
%token RR_FUNCT
%token WS_FUNCT
%token WI_FUNCT
%token WR_FUNCT

/* Non-terminal symbols */
%type <string> program data_type expr statement var_decl const_decl function
%type <string> decl_list decl body func_decl array
%type <string> expr1 var_decl1 var_decl2 const1 param param1
%type <string> if_stmt for_stmt while_stmt return_stmt simple_stmt func_stmt func_params assign_stmt
/* %type <string> special_func rs_func ri_func rr_func ws_func wi_func wr_func */


/* The first symbol */
%start func_decl

/* Rules */
%%

program: decl_list KEYWORD_FUNC KEYWORD_BEGIN 
         L_PAREN R_PAREN L_CURLY_BRACKET body R_CURLY_BRACKET { 
  /* We have a successful parse! 
    Check for any errors and generate output. 
  */
  if (yyerror_count == 0) {
    // include the pilib.h file
    puts(c_prologue); 
    printf("typedef char* string");
    printf("/* program */ \n\n");
    printf("%s\n\n", $1);
    printf("int main() {\n%s\n} \n", $7);
  }
}
;

decl_list: decl_list decl   { $$ = template("%s\n%s", $1, $2); }
         | decl             { $$ = $1; }
;

/* Function declarations and global vars */
decl: var_decl    { $$ = $1; }
    | const_decl  { $$ = $1; }
    | func_decl   { $$ = $1; }
    | function    { $$ = $1; }
;
 
/* Body of the main fucnction */
body: var_decl      { $$ = $1; }
    | const_decl    { $$ = $1; }
    | func_decl     { $$ = $1; }
    | statement     { $$ = $1; }
    /* | special_func  { $$ = $1; } */
;

expr: expr1                  { $$ = $1; } 
    | MINUS_OP expr          { $$ = template("-%s", $2); }    //not sure
    | L_PAREN expr R_PAREN   { $$ = template("(%s)", $2); }
    | expr1 PLUS_OP expr     { $$ = template("%s + %s", $1, $3); }
    | expr1 MINUS_OP expr    { $$ = template("%s - %s", $1, $3); }
    | expr1 MULT_OP expr     { $$ = template("%s * %s", $1, $3); }
    | expr1 DIV_OP expr      { $$ = template("%s / %s", $1, $3); }
    | expr1 MOD_OP expr      { $$ = template("%s \% %s", $1, $3); }
    | expr1 POWER_OP expr    { $$ = template("%s ** %s", $1, $3); }
    | IDENTIFIER L_BRACKET expr R_BRACKET { $$ = template("%s[%s]", $1, $3); }
    | func_stmt              { $$ = $1; }
    /* special func */
    | NOT_LOGIC_OP expr          { $$ = template("!%s", $2); }
    | expr1 AND_LOGIC_OP expr    { $$ = template("%s && %s", $1, $3); }
    | expr1 OR_LOGIC_OP expr     { $$ = template("%s || %s", $1, $3); }
    | expr1 EQUALS_OP expr       { $$ = template("%s == %s", $1, $3); }
    | expr1 NOT_EQUALS_OP expr   { $$ = template("%s != %s", $1, $3); }
    | expr1 GREATER_EQ_OP expr   { $$ = template("%s >= %s", $1, $3); }
    | expr1 LESS_EQ_OP expr      { $$ = template("%s <= %s", $1, $3); }
    | expr1 GREATER_OP expr      { $$ = template("%s > %s", $1, $3); }
    | expr1 LESS_OP expr         { $$ = template("%s < %s", $1, $3); }
    | KEYWORD_TRUE               { $$ = "1"; }
    | KEYWORD_FALSE              { $$ = "0"; }
;

expr1: IDENTIFIER    { $$ = $1; } 
     | INTEGER       { $$ = $1; }
     | REAL          { $$ = $1; } 
     /* | CONST_STRING          { $$ = $1; } */
;

data_type: KEYWORD_INT      { $$ = template("int"); }
         | KEYWORD_REAL     { $$ = template("double"); }
         | KEYWORD_STRING   { $$ = template("string"); }   //typedef at the start of .c file
         | KEYWORD_BOOL     { $$ = template("int"); }
;

array: IDENTIFIER L_BRACKET expr R_BRACKET   { $$ = template("%s[%s]", $1, $3); }    //not sure
     | IDENTIFIER L_BRACKET R_BRACKET        { $$ = template("*%s", $1); }
;

/* array: IDENTIFIER L_BRACKET expr R_BRACKET data_type   { $$ = template("%s %s[%s]", $5, $1, $3); }    //not sure
     | IDENTIFIER L_BRACKET R_BRACKET data_type        { $$ = template("%s %s[]", $4, $1); }
; */

/* var declaration */
var_decl: KEYWORD_VAR var_decl2 data_type SEMICOLON {$$ = template("%s %s;", $3, $2); }
;

var_decl2: var_decl1 COMMA var_decl2    { $$ = template("%s , %s", $1, $3); }
         | var_decl1 { $$ = $1; }
;

var_decl1: IDENTIFIER ASSIGN_OP expr            { $$ = template("%s = %s", $1, $3); }
         | IDENTIFIER                           { $$ = $1; }
         | IDENTIFIER ASSIGN_OP CONST_STRING    { $$ = template("%s = %s", $1, $3); }
         | array                                { $$ = $1; }
;

/* const declaration */
const_decl: KEYWORD_CONST const1 data_type SEMICOLON { $$ = template("const %s %s;\n", $3, $2); }
;

const1: IDENTIFIER ASSIGN_OP expr           { $$ = template("%s = %s", $1, $3); }
      | IDENTIFIER ASSIGN_OP CONST_STRING   { $$ = template("%s = %s", $1, $3); }
;

/* function declaration */
func_decl: KEYWORD_FUNC IDENTIFIER L_PAREN param R_PAREN data_type SEMICOLON
           { $$ = template("%s %s(%s);", $6, $2, $4); printf("\n%s\n", $$); }
;

/* function construction  */    //needs work
function: KEYWORD_FUNC IDENTIFIER L_PAREN param R_PAREN data_type L_CURLY_BRACKET body R_CURLY_BRACKET 
          { $$ = template("%s %s(%s) {\n%s}\n", $6, $2, $4, $8); }
;

/* function declaration parameters */
param1: IDENTIFIER data_type                 { $$ = template("%s %s", $2, $1); }
      | array data_type                      { $$ = template("%s %s", $2, $1); }
;

param: param1 COMMA param     { $$ = template("%s, %s", $1, $3); }
     | param1                  { $$ = $1; }
;

/* special fucntions */     // needs work
/* special_func: rs_func { $$ = $1; }
            | ri_func { $$ = $1; }
            | rr_func { $$ = $1; }
            | ws_func { $$ = $1; }
            | wi_func { $$ = $1; }
            | wr_func { $$ = $1; }
;

rs_func: RS_FUNCT L_PAREN R_PAREN SEMICOLON
;

ri_func: RI_FUNCT L_PAREN R_PAREN SEMICOLON
;

rr_func: RR_FUNCT L_PAREN R_PAREN SEMICOLON
;

ws_func: WS_FUNCT L_PAREN IDENTIFIER R_PAREN SEMICOLON 
       | WS_FUNCT L_PAREN CONST_STRING R_PAREN SEMICOLON 
;

wi_func: WI_FUNCT L_PAREN IDENTIFIER R_PAREN SEMICOLON 
       | WI_FUNCT L_PAREN INTEGER R_PAREN SEMICOLON 
;

wr_func: WR_FUNCT L_PAREN IDENTIFIER R_PAREN SEMICOLON 
       | WR_FUNCT L_PAREN REAL R_PAREN SEMICOLON 
; */

statement: L_CURLY_BRACKET statement R_CURLY_BRACKET      { $$ = template("{%s}", $2); }
         | simple_stmt                  { $$ = $1; }
         /* | simple_stmt simple_stmt      { $$ = template("%s\n%s", $1, $2); } */
;

simple_stmt: KEYWORD_CONTINUE   { $$ = template("continue;\n"); }
           | KEYWORD_BREAK      { $$ = template("break;\n"); }
           | assign_stmt        { $$ = $1; }
           | if_stmt            { $$ = $1; }
           | for_stmt           { $$ = $1; }
           | while_stmt         { $$ = $1; }
           | func_stmt          { $$ = template("%s;", $1); }
           | return_stmt        { $$ = $1; }
;

assign_stmt: IDENTIFIER ASSIGN_OP expr      { $$ = template("%s = %s", $1, $3); }
;

if_stmt: KEYWORD_IF L_PAREN expr R_PAREN statement      { $$ = template("if(%s)\n%s\n", $3, $5); }
       /* | KEYWORD_ELSE if_stmt                           { $$ = template("else %s", $2); } */
       | KEYWORD_ELSE statement                         { $$ = template("else %s", $2); }
;

for_stmt: KEYWORD_FOR L_PAREN assign_stmt SEMICOLON expr SEMICOLON assign_stmt R_PAREN statement
          { $$ = template("for(%s; %s; %s)\n%s\n", $3, $5, $7, $9); }
;

while_stmt: KEYWORD_WHILE L_PAREN expr R_PAREN statement    { $$ = template("while(%s)\n%s\n", $3, $5); }
;

func_stmt: IDENTIFIER L_PAREN func_params R_PAREN SEMICOLON { $$ = template("%s(%s)", $1, $3); } 
;

func_params: expr COMMA expr    { $$ = template("%s, %s", $1, $3); }
           | expr               { $$ = $1; }

return_stmt: KEYWORD_RETURN expr SEMICOLON   { $$ = template("return %s;\n", $2); }
           | KEYWORD_RETURN expr             { $$ = template("return;\n"); }
;


%%
int main() {
    if (yyparse() == 0)
        printf("Accepted\n");
    else
        printf("Rejected\n");
}
