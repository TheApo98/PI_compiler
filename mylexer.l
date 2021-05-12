%{
#include <stdio.h>    
#include "helperFiles/pilib.h"
int lineNum = 1;
%}

ID      [a-zA-Z][0-9a-zA-Z_]*
DIGIT   [0-9]
NUMBER  [+-]?{DIGIT}{DIGIT}*
DECIMAL ([+-]?"."{NUMBER})|([+-]?{NUMBER}("."{NUMBER}?)?)
REAL    {DECIMAL}([eE][+-]?{NUMBER})?


/* Rules */
%%
"int"                   { printf("KEYWORD: %s\n", yytext); }
"real"                  { printf("KEYWORD: %s\n", yytext); }
"string"                { printf("KEYWORD: %s\n", yytext); }
"bool"                  { printf("KEYWORD: %s\n", yytext); }
"true"                  { printf("KEYWORD: %s\n", yytext); }
"false"                 { printf("KEYWORD: %s\n", yytext); }
"var"                   { printf("KEYWORD: %s\n", yytext); }
"const"                 { printf("KEYWORD: %s\n", yytext); }
"if"                    { printf("KEYWORD: %s\n", yytext); }
"else"                  { printf("KEYWORD: %s\n", yytext); }
"for"                   { printf("KEYWORD: %s\n", yytext); }
"while"                 { printf("KEYWORD: %s\n", yytext); }
"break"                 { printf("KEYWORD: %s\n", yytext); }
"continue"              { printf("KEYWORD: %s\n", yytext); }
"func"                  { printf("KEYWORD: %s\n", yytext); }
"nil"                   { printf("KEYWORD: %s\n", yytext); }
"and"                   { printf("KEYWORD: %s\n", yytext); }
"or"                    { printf("KEYWORD: %s\n", yytext); }
"not"                   { printf("KEYWORD: %s\n", yytext); }
"return"                { printf("KEYWORD: %s\n", yytext); }
"begin"                 { printf("KEYWORD: %s\n", yytext); }

{ID}                    { printf("IDENTIFIER: %s\n", yytext); }
[ \t\r]+                /* White Space */
"="                     { printf("ASSIGN_OP: %s\n", yytext); }
"+"                     { printf("PLUS_OP: %s\n", yytext); }
"-"                     { printf("MINUS_OP: %s\n", yytext); }
"*"                     { printf("MULT_OP: %s\n", yytext); }
";"                     { printf("SEMICOLON: %s\n", yytext); }



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