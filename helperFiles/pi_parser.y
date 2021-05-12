%{
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>		
#include "cgen.h"

extern int yylex(void);
extern int line_num;
%}

%union
{
	char* crepr;
}


 
%token <crepr> STRING

%token KW_BEGIN
%token KW_FUNC

%token ASSIGN

%start program

%type <crepr> decl_list body decl

%%

program: decl_list KW_FUNC KW_BEGIN '(' ')' '{' body '}' { 

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

decl_list: 
decl_list decl { $$ = template("%s\n%s", $1, $2); }
| decl { $$ = $1; }
;

decl:  {$$="";}
;
 

body: { $$="";}
;

%%
int main () {
  if ( yyparse() != 0 )
    printf("Rejected!\n");
}

