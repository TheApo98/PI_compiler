#/bin/bash

# *** Be careful , error handling is NOT implemented ***

# Assign new human-readable variables for the arguments  
example=$1
# echo $lexfile
# echo $example

# Compile the .y file
bison -d -v -r all myanalyzer.y

# Compile the .l file
flex mylexer.l

# Compile the .c file
gcc -o mycompiler myanalyzer.tab.c lex.yy.c helperFiles/cgen.c -lfl

# Run the executable with the .pi file
./mycompiler < examples/"$example" 
# > "$example".c

# Split the filename using the delimiter '.'
IFS='.'
read -a str <<< "$example"

# echo ${str[0]}
mv program.c ${str[0]}.c

gcc -o ${str[0]} ${str[0]}.c -lm
./${str[0]}