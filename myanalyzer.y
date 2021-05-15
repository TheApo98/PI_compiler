%{
    #include <stdio.h>
    #include <stdlib.h>

%}

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
%token PLUS_OP    
%token MINUS_OP    
%token MULT_OP    
%token MOD_OP     
%token POWER_OP    
%token LESS_OP    
%token GREATER_OP   
%token LESS_EQ_OP   
%token GREATER_EQ_OP  
%token EQUALS_OP   
%token NOT_EQUALS_OP  
%token AND_LOGIC_OP  
%token OR_LOGIC_OP  
%token NOT_LOGIC_OP  

/* Delimiters */
%token SEMICOLON   
%token L_PARENTHESIS  
%token R_PARENTHESIS  
%token COMMA     
%token L_BRACKET   
%token R_BRACKET   
%token L_CURLY_BRACKET

%token CONST_STRING
%token INTEGER  
%token REAL             
%token IDENTIFIER  

/* Special functions */
%token RS_FUNC
%token RI_FUNC
%token RR_FUNC
%token WS_FUNC
%token WI_FUNC
%token WR_FUNC

/* Rules */
%%





%%
int main() {
    if (yyparse() == 0)
        printf("Accepted\n");
    else
        printf("rejected\n");
}
