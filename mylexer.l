%{
#include <stdio.h>    
#include "helperFiles/pilib.h"
int lineNum = 1;
%}

/* Rules */
%%

[a-zA-Z][a-zA-Z0-9_]*   { printf("IDENTIFIER: %s\n", yytext); }
[ \t\r]+                /* White Space */
"="                     { printf("ASSIGN_OP: %s\n", yytext); }
"+"                     { printf("PLUS_OP: %s\n", yytext); }
"-"                     { printf("MINUS_OP: %s\n", yytext); }
"*"                     { printf("MULT_OP: %s\n", yytext); }
";"                     { printf("SEMICOLUMN: %s\n", yytext); }

"//"[^\n]*  		    { printf("Line %d: line comment: %s\n", lineNum, yytext); }
.                       { printf("Unrecognized Token %s in line %d: %s\n", yytext, lineNum, "test"); }
\n { lineNum++; }

<<EOF>>                 { return EOF; }
%%


int main() {
    /* printf("Start\n"); */
    if (yylex() == EOF){
        exit(0);
    }
    return 0;
}