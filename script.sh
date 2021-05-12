#/bin/bash

# *** Be careful , error handling is NOT implemented ***

# Assign new human-readable variables for the arguments  
lexfile=$1
example=$2
# echo $lexfile
# echo $example

# Split the filename using the delimiter '.'
IFS='.'
read -a str <<< "$lexfile"
# echo ${str[0]}

# Compile the .l file
flex "$lexfile"

# Compile the .c file
gcc -o ${str[0]} lex.yy.c -lfl

# Run the executable with the .in file
./${str[0]} < "$example"
