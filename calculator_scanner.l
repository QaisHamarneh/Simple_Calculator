%{
#include "y.tab.h"
#include "header.h"
void yyerror (char *s);
int yylex();
%}
%%

"quit"                      {return eoProg;}
[a-z]+  		            {yylval.id = yytext; return var;}
[1-9][0-9]*\.[0-9]*         {yylval.num = atof(yytext) ; return number;}
0?\.[1-9][0-9]*             {yylval.num = atof(yytext) ; return number;}

[1-9][0-9]*                 {yylval.num = atof(yytext); return number;}
[0]                         {yylval.num = atof(yytext); return number;}

[\n]			            {return eoLine;}
[;]	    		            {return eoExp;}

(==)                        {return eq;}
(!=)                        {return n_eq;}
(<=)                        {return ls_eq;}
(>=)                        {return gr_eq;}
[-+=*/^!<>]           	    {return yytext[0];}
[()]                        {return yytext[0];}
[ \t]                       ;
.                           {ECHO; yyerror ("unexpected character");}
%%

int yywrap (void)  {return 1;}
