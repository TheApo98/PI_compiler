%{
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "pi_parser.tab.h"
#include "cgen.h"

int line_num = 1;

%}

DIGIT  [0-9]
NUM  {DIGIT}{DIGIT}*
STRING  '[^'\n]*'

%x comment

%%
begin return KW_BEGIN;
func   return KW_FUNC;

{STRING}   { yylval.crepr = strdup(yytext); return STRING; }

"="	return ASSIGN;
";" 	return ';';
")"	return ')';
"("	return '(';
"{"	return '{';
"}"	return '}';

"//"[^\n]*  	/* eat line comments */

"/*"		BEGIN(comment);
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++line_num;
<comment>"*"+"/"        BEGIN(INITIAL);


[ \r\t]		/* skip whitespace */
\n 		++line_num;
<<EOF>> 	return EOF;

.             { yyerror("lexical error: unrecognized literal '%s'\n", yytext); }


%%


