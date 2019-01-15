%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
#include "header.h"
#include <string.h>
#include <stdbool.h>

double getVariable(char *name);
void updateVariable(char *name, double val);

%}

%union {double num; char *id;}
%start line
%token eoProg eoExp eoLine
%token eq n_eq ls_eq gr_eq 
%token <num> number
%token <id> var
%type <num> line rel_op assign_op add_op mul_op pow_op unary parenth factor

%left eq n_eq ls_eq gr_eq '<' '>'
%right '='
%left '+'
%left '*' '/'
%right '^'
%nonassoc '-'

%%

line   		: rel_op eoExp			            {printf("=> %.10g\n", $1);}
	    	| line rel_op eoExp		            {printf("=> %.10g\n", $2);}
            | rel_op eoLine			            {printf("=> %.10g\n-> ", $1);}
	    	| line rel_op eoLine		        {printf("=> %.10g\n-> ", $2);}
            | line eoLine                       {printf("-> ");}
            | line eoProg eoLine                {exit(EXIT_SUCCESS);}
            | eoProg eoLine                     {exit(EXIT_SUCCESS);}
            | line eoProg eoExp eoLine          {exit(EXIT_SUCCESS);}
            | eoProg eoExp eoLine               {exit(EXIT_SUCCESS);}
       		;
        
rel_op   	: rel_op eq     assign_op       	{$$ = ($1 == $3)? 1 : 0; }
	    	| rel_op n_eq   assign_op       	{$$ = ($1 != $3)? 1 : 0; }
	    	| rel_op ls_eq  assign_op       	{$$ = ($1 <= $3)? 1 : 0; }
	    	| rel_op gr_eq  assign_op       	{$$ = ($1 >= $3)? 1 : 0; }
	    	| rel_op '<'    assign_op       	{$$ = ($1 < $3)? 1 : 0; }
            | rel_op '>'    assign_op      	    {$$ = ($1 > $3)? 1 : 0; }
        	| assign_op                      	{$$ = $1;}
        	;
   
assign_op 	: var '=' assign_op              	{$$ = $3; updateVariable($1,$3);}
           	| add_op                     	  	{$$ = $1;}
	    	;
			
add_op 	   	: add_op '+' mul_op         	    {$$ = $1 + $3;}
       		| add_op '-' mul_op   %prec '+'    	{$$ = $1 - $3;}
            | mul_op                  	        {$$ = $1;}
   	    	
       		;
mul_op   	: mul_op '*' pow_op                	{$$ = $1 * $3;}
        	| mul_op '/' pow_op                	{$$ = $1 / $3;}
        	| pow_op                         	{$$ = $1;}
       		;
pow_op 		: unary '^' pow_op	  	            {$$ = pow($1 , $3);}
       		| unary	                        	{$$ = $1;}
       		;
unary	  	: '-' parenth		                {$$ = -1 * $2;}
		    | parenth 	         	            {$$ = $1;}
	        ;
parenth  	: '(' rel_op ')'       	            {$$ = $2; }
		    | factor          		            {$$ = $1;}
	        ;
factor  	: number                	        {$$ = $1;}
		    | var       		            	{$$ = getVariable($1);} 
	        ;

%%                     /* C code */


double getVariable(char *name)
{
	
    char *varName = strtok(name, " ;=!+-()*/><^\n");

	return lookup(varName);
}

void updateVariable(char *name, double val)
{
    char *varName = strtok(name, " ;=!+-()*/><^\n");

    insert(varName, val);
}

int main (void) {
	//init symbol table 
	initTable();

	printf("-> ");

	return yyparse ();
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 

