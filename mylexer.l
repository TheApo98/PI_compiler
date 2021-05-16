%{
#include <stdio.h>    
#include <string.h>
#include "myanalyzer.tab.h"
#include "helperFiles/cgen.h"

int line_num = 1;
%}

ID      [a-zA-Z][0-9a-zA-Z_]*
DIGIT   [0-9]
NUMBER  {DIGIT}{DIGIT}*
DECIMAL ("."{NUMBER})|({NUMBER}("."{NUMBER}?)?)
REAL    {DECIMAL}([eE][+-]?{NUMBER})?
STRING  \"[^\"\n]*\"


%x comment

/* Rules */
%%
"int"                   { printf("token KEYWORD_INT: %s\n", yytext); return KEYWORD_INT; }    /* Keywords */
"real"                  { printf("token KEYWORD_REAL: %s\n", yytext); return KEYWORD_REAL; }
"string"                { printf("token KEYWORD_STRING: %s\n", yytext); return KEYWORD_STRING; }
"bool"                  { printf("token KEYWORD_BOOL: %s\n", yytext); return KEYWORD_BOOL; }
"true"                  { printf("token KEYWORD_TRUE: %s\n", yytext); return KEYWORD_TRUE; }
"false"                 { printf("token KEYWORD_FALSE: %s\n", yytext); return KEYWORD_FALSE; }
"var"                   { printf("token KEYWORD_VAR: %s\n", yytext); return KEYWORD_VAR; }
"const"                 { printf("token KEYWORD_CONST: %s\n", yytext); return KEYWORD_CONST; }
"if"                    { printf("token KEYWORD_IF: %s\n", yytext); return KEYWORD_IF; }
"else"                  { printf("token KEYWORD_ELSE: %s\n", yytext); return KEYWORD_ELSE; }
"for"                   { printf("token KEYWORD_FOR: %s\n", yytext); return KEYWORD_FOR; }
"while"                 { printf("token KEYWORD_WHILE: %s\n", yytext); return KEYWORD_WHILE; }
"break"                 { printf("token KEYWORD_BREAK: %s\n", yytext); return KEYWORD_BREAK; }
"continue"              { printf("token KEYWORD_CONTINUE: %s\n", yytext); return KEYWORD_CONTINUE; }
"func"                  { printf("token KEYWORD_FUNC: %s\n", yytext); return KEYWORD_FUNC; }
"nil"                   { printf("token KEYWORD_NIL: %s\n", yytext); return KEYWORD_NIL; }
"return"                { printf("token KEYWORD_RETURN: %s\n", yytext); return KEYWORD_RETURN; }
"begin"                 { printf("token KEYWORD_BEGIN: %s\n", yytext); return KEYWORD_BEGIN; }
 
"="                     { printf("token ASSIGN_OP: %s\n", yytext); return ASSIGN_OP; }  /* Operators */
"+"                     { printf("token PLUS_OP: %s\n", yytext); return PLUS_OP; }
"-"                     { printf("token MINUS_OP: %s\n", yytext); return MINUS_OP; }
"*"                     { printf("token MULT_OP: %s\n", yytext); return MULT_OP; }
"/"                     { printf("token DIV_OP: %s\n", yytext); return DIV_OP; }
"%"                     { printf("token MOD_OP: %s\n", yytext); return MOD_OP; }
"**"                    { printf("token POWER_OP: %s\n", yytext); return POWER_OP; }
"<"                     { printf("token LESS_OP: %s\n", yytext); return LESS_OP; }
">"                     { printf("token GREATER_OP: %s\n", yytext); return GREATER_OP; }
"<="                    { printf("token LESS_EQ_OP: %s\n", yytext); return LESS_EQ_OP; }
">="                    { printf("token GREATER_EQ_OP: %s\n", yytext); return GREATER_EQ_OP; }
"=="                    { printf("token EQUALS_OP: %s\n", yytext); return EQUALS_OP; }
"!="                    { printf("token NOT_EQUALS_OP: %s\n", yytext); return NOT_EQUALS_OP; }
"and"                   { printf("token AND_LOGIC_OP: %s\n", yytext); return AND_LOGIC_OP; }
"or"                    { printf("token OR_LOGIC_OP: %s\n", yytext); return OR_LOGIC_OP; }
"not"                   { printf("token NOT_LOGIC_OP: %s\n", yytext); return NOT_LOGIC_OP; }

";"                     { printf("token SEMICOLON: %s\n", yytext); return SEMICOLON; }  /* Delimiters */
"("                     { printf("token L_PARENTHESIS: %s\n", yytext); return L_PARENTHESIS; }
")"                     { printf("token R_PARENTHESIS: %s\n", yytext); return R_PARENTHESIS; }
","                     { printf("token COMMA: %s\n", yytext); return COMMA; }
"["                     { printf("token L_BRACKET: %s\n", yytext); return L_BRACKET; }
"]"                     { printf("token R_BRACKET: %s\n", yytext); return R_BRACKET; }
"{"                     { printf("token L_CURLY_BRACKET: %s\n", yytext); return L_CURLY_BRACKET; }
"}"                     { printf("token R_CURLY_BRACKET: %s\n", yytext); return R_CURLY_BRACKET; }


"readString"            { printf("token RS_FUNC: %s\n", yytext); return RS_FUNC; }  /* Functions */
"readInt"               { printf("token RI_FUNC: %s\n", yytext); return RI_FUNC; }
"readReal"              { printf("token RR_FUNC: %s\n", yytext); return RR_FUNC; }
"writeString"           { printf("token WS_FUNC: %s\n", yytext); return WS_FUNC; }
"writeInt"              { printf("token WI_FUNC: %s\n", yytext); return WI_FUNC; }
"writeReal"             { printf("token WR_FUNC: %s\n", yytext); return WR_FUNC; }

{STRING}                { printf("token CONST_STRING: %s\n", yytext); return CONST_STRING; yylval.string = strdup(yytext); }
{NUMBER}                { printf("token INTEGER: %s\n", yytext); return INTEGER; yylval.string = strdup(yytext); }
{REAL}                  { printf("token REAL: %s\n", yytext); return REAL; yylval.string = strdup(yytext); }

{ID}                    { printf("token IDENTIFIER: %s\n", yytext); return IDENTIFIER; yylval.string = strdup(yytext); } /* Identifiers */
[ \t\r]+                /* White Space */

"//"[^\n]*  		    /* Comments */
"/*"                    { BEGIN(comment); }
<comment>[^*\n]*        /* eat anything that's not a '*' */ 
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */ 
<comment>\n             line_num++; 
<comment>"*"+"/"        { BEGIN(INITIAL); }


.                       { printf("Unrecognized Token %s in line %d: %s\n", yytext, line_num, "test"); exit(1); }
\n                      { line_num++; }

<<EOF>>                 { exit(0); }
%%


