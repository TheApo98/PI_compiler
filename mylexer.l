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

%x comment

/* Rules */
%%
"int"                   { printf("KEYWORD: %s\n", yytext); }    /* Keywords */
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
"return"                { printf("KEYWORD: %s\n", yytext); }
"begin"                 { printf("KEYWORD: %s\n", yytext); }

"="                     { printf("ASSIGN_OP: %s\n", yytext); }  /* Operators */
"+"                     { printf("PLUS_OP: %s\n", yytext); }
"-"                     { printf("MINUS_OP: %s\n", yytext); }
"*"                     { printf("MULT_OP: %s\n", yytext); }
"%"                     { printf("MOD_OP: %s\n", yytext); }
"**"                    { printf("POWER_OP: %s\n", yytext); }
"<"                     { printf("LESS_OP: %s\n", yytext); }
">"                     { printf("GREATER_OP: %s\n", yytext); }
"<="                    { printf("LESS_EQ_OP: %s\n", yytext); }
">="                    { printf("GREATER_EQ_OP: %s\n", yytext); }
"=="                    { printf("EQUALS_OP: %s\n", yytext); }
"!="                    { printf("NOT_EQUALS_OP: %s\n", yytext); }
"and"                   { printf("AND_LOGIC_OP: %s\n", yytext); }
"or"                    { printf("OR_LOGIC_OP: %s\n", yytext); }
"not"                   { printf("NOT_LOGIC_OP: %s\n", yytext); }


";"                     { printf("SEMICOLON: %s\n", yytext); }  /* Delimiters */
"("                     { printf("L_PARENTHESIS: %s\n", yytext); }
")"                     { printf("R_PARENTHESIS: %s\n", yytext); }
","                     { printf("COMMA: %s\n", yytext); }
"["                     { printf("L_BRACKET: %s\n", yytext); }
"]"                     { printf("R_BRACKET: %s\n", yytext); }
"{"                     { printf("L_CUR_BRACKET: %s\n", yytext); }
"}"                     { printf("R_CUR_BRACKET: %s\n", yytext); }

{ID}                    { printf("IDENTIFIER: %s\n", yytext); } /* Identifiers */
[ \t\r]+                /* White Space */


"//"[^\n]*  		    { printf("LINE_COMMENT: %s\n", yytext); } /* Comments */
"/*"                    { BEGIN(comment); printf("comment started at line: %d\n", lineNum); }
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             lineNum++;
<comment>"*"+"/"        { BEGIN(INITIAL); printf("comment ended at line: %d\n", lineNum); }


.                       { printf("Unrecognized Token %s in line %d: %s\n", yytext, lineNum, "test"); }
\n                      { lineNum++; }

<<EOF>>                 { return EOF; }
%%


int main() {
    /* printf("Start\n"); */
    if (yylex() == EOF){
        exit(0);
    }
    return 0;
}