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

%union {double num; char *id;}         /* Yacc definitions */
%start line
%token stop_command
%token eq n_eq ls_eq gr_eq eol
%token <num> number
%token <id> identifier
%type <num> line exp term power factor compare assignment parenth unary

%left eq n_eq ls_eq gr_eq '<' '>'
%right '='
%left '+'
%left '*' '/'
%right '^'
%nonassoc '-'
%%

/* descriptions of expected inputs     corresponding actions (in C) */

line   		: compare eol			            {printf("=> %.10g\n-> ", $1);}
	    	| line compare eol		            {printf("=> %.10g\n-> ", $2);}
            | line stop_command eol            	{exit(EXIT_SUCCESS);}
            | stop_command eol                 	{exit(EXIT_SUCCESS);}
       		;
        
compare 	: compare eq     assignment      	{$$ = ($1 == $3)? 1 : 0; }
	    	| compare n_eq   assignment       	{$$ = ($1 != $3)? 1 : 0; }
	    	| compare ls_eq  assignment      	{$$ = ($1 <= $3)? 1 : 0; }
	    	| compare gr_eq  assignment      	{$$ = ($1 >= $3)? 1 : 0; }
	    	| compare '<'    assignment      	{$$ = ($1 < $3)? 1 : 0; }
            | compare '>'    assignment      	{$$ = ($1 > $3)? 1 : 0; }
        	| assignment                      	{$$ = $1;}
        	;
   
assignment 	: identifier '=' assignment     	{$$ = $3; updateVariable($1,$3);}
           	| exp                     	    	{$$ = $1;}
	    	;
			
exp 	   	: term                  	        {$$ = $1;}
   	    	| exp '+' term         		        {$$ = $1 + $3;}
       		| exp '-' term   %prec '+'         	{$$ = $1 - $3;}
       		;
term   		: term '*' power                	{$$ = $1 * $3;}
        	| term '/' power                	{$$ = $1 / $3;}
        	| power                         	{$$ = $1;}
       		;
power  		: unary '^' power	  	            {$$ = pow($1 , $3);}
       		| unary	                        	{$$ = $1;}
       		;
unary	  	: '-' parenth		                {$$ = -1 * $2;}
		    | parenth 	         	            {$$ = $1;}
	        ;
parenth  	: '(' compare ')'       	        {$$ = $2; }
		    | factor          		            {$$ = $1;}
	        ;
factor  	: number                	        {$$ = $1;}
		    | identifier		            	{$$ = getVariable($1);} 
	        ;

%%                     /* C code */


double getVariable(char *name)
{
	
    char *varName = strtok(name, " =!+-()*/><^\n");

    node_t *variable = lookup(varName);
	
	return variable->value;
	
}

void updateVariable(char *name, double val)
{
    char *varName = strtok(name, " =!+-()*/><^\n");

    insert(varName, val);
}

int main (void) {
	//init symbol table 
	initTable();

	printf("-> ");

	return yyparse ();
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 

