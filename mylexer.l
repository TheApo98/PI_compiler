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

%x string
%x comment

/* Rules */
%%
"int"                   { printf("token KEYWORD_INT: %s\n", yytext); }    /* Keywords */
"real"                  { printf("token KEYWORD_REAL: %s\n", yytext); }
"string"                { printf("token KEYWORD_STRING: %s\n", yytext); }
"bool"                  { printf("token KEYWORD_BOOL: %s\n", yytext); }
"true"                  { printf("token KEYWORD_TRUE: %s\n", yytext); }
"false"                 { printf("token KEYWORD_FALSE: %s\n", yytext); }
"var"                   { printf("token KEYWORD_VAR: %s\n", yytext); }
"const"                 { printf("token KEYWORD_CONST: %s\n", yytext); }
"if"                    { printf("token KEYWORD_IF: %s\n", yytext); }
"else"                  { printf("token KEYWORD_ELSE: %s\n", yytext); }
"for"                   { printf("token KEYWORD_FOR: %s\n", yytext); }
"while"                 { printf("token KEYWORD_WHILE: %s\n", yytext); }
"break"                 { printf("token KEYWORD_BREAK: %s\n", yytext); }
"continue"              { printf("token KEYWORD_CONTINUE: %s\n", yytext); }
"func"                  { printf("token KEYWORD_FUNC: %s\n", yytext); }
"nil"                   { printf("token KEYWORD_NIL: %s\n", yytext); }
"return"                { printf("token KEYWORD_RETURN: %s\n", yytext); }
"begin"                 { printf("token KEYWORD_BEGIN: %s\n", yytext); }
 
"="                     { printf("token ASSIGN_OP: %s\n", yytext); }  /* Operators */
"+"                     { printf("token PLUS_OP: %s\n", yytext); }
"-"                     { printf("token MINUS_OP: %s\n", yytext); }
"*"                     { printf("token MULT_OP: %s\n", yytext); }
"%"                     { printf("token MOD_OP: %s\n", yytext); }
"**"                    { printf("token POWER_OP: %s\n", yytext); }
"<"                     { printf("token LESS_OP: %s\n", yytext); }
">"                     { printf("token GREATER_OP: %s\n", yytext); }
"<="                    { printf("token LESS_EQ_OP: %s\n", yytext); }
">="                    { printf("token GREATER_EQ_OP: %s\n", yytext); }
"=="                    { printf("token EQUALS_OP: %s\n", yytext); }
"!="                    { printf("token NOT_EQUALS_OP: %s\n", yytext); }
"and"                   { printf("token AND_LOGIC_OP: %s\n", yytext); }
"or"                    { printf("token OR_LOGIC_OP: %s\n", yytext); }
"not"                   { printf("token NOT_LOGIC_OP: %s\n", yytext); }

";"                     { printf("token SEMICOLON: %s\n", yytext); }  /* Delimiters */
"("                     { printf("token L_PARENTHESIS: %s\n", yytext); }
")"                     { printf("token R_PARENTHESIS: %s\n", yytext); }
","                     { printf("token COMMA: %s\n", yytext); }
"["                     { printf("token L_BRACKET: %s\n", yytext); }
"]"                     { printf("token R_BRACKET: %s\n", yytext); }
"{"                     { printf("token L_CURLY_BRACKET: %s\n", yytext); }
"}"                     { printf("token R_CURLY_BRACKET: %s\n", yytext); }

\"                      { BEGIN(string); printf("STRING: %s\n", yytext); }
<string>[^\n]* 
<string>\"              { BEGIN(INITIAL); printf("STRING: %s\n", yytext); }

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