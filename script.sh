#/bin/bash
lexfile=$1
example=$2
# echo $lexfile
# echo $example
IFS='.'
read -a str <<< "$lexfile"
# echo ${str[0]}
flex "$lexfile"
gcc -o ${str[0]} lex.yy.c -lfl
./${str[0]} < "$example"
