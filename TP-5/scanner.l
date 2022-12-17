%{
#include <stdio.h>
#include "parser.h"
#include "calc.h"
%}

%option header-file="scanner.h"
%option outfile="scanner.c"
%option noinput
%option nounput

digito  [0-9]
letra [A-Za-z]
exponencial [eE][+-]?{digito}+
fraccion {digito}*\.{digito}+|{digito}+\.
invalido [^A-Za-z0-9 ()\n+\-*/^]
error_real [0-9.]

%%

salir                                                           {yylval.cadena = strdup(yytext); return SALIR;}
var                                                             {yylval.cadena = strdup(yytext); return VAR;}
cte                                                             {yylval.cadena = strdup(yytext); return CTE;}
sin                                                             {yylval.cadena = strdup(yytext); return FUNCION;}
cos                                                             {yylval.cadena = strdup(yytext); return FUNCION;}
tan                                                             {yylval.cadena = strdup(yytext); return FUNCION;}
asin                                                            {yylval.cadena = strdup(yytext); return FUNCION;}
acos                                                            {yylval.cadena = strdup(yytext); return FUNCION;}
atan                                                            {yylval.cadena = strdup(yytext); return FUNCION;}
sqrt                                                            {yylval.cadena = strdup(yytext); return FUNCION;}
log                                                             {yylval.cadena = strdup(yytext); return FUNCION;}
\+                                                              {yylval.cadena = strdup(yytext); return '+';}
-                                                               {yylval.cadena = strdup(yytext); return '-';}
\*                                                              {yylval.cadena = strdup(yytext); return '*';}
\/                                                              {yylval.cadena = strdup(yytext); return '/';}
\^                                                              {yylval.cadena = strdup(yytext); return '^';}
\(                                                              {yylval.cadena = strdup(yytext); return '(';}
\)                                                              {yylval.cadena = strdup(yytext); return ')';}
=                                                               {yylval.cadena = strdup(yytext); return '=';}
\+=                                                             {yylval.cadena = strdup(yytext); return OP_ASIG_SUMA;}
-=                                                              {yylval.cadena = strdup(yytext); return OP_ASIG_RESTA;}
\*=                                                             {yylval.cadena = strdup(yytext); return OP_ASIG_MULT;}
\/=                                                             {yylval.cadena = strdup(yytext); return OP_ASIG_DIV;}

{digito}+                                                       {sscanf(yytext, "%lf", &yylval.num); return ENTERO;}
{digito}({digito}|{letra})+                                     {yyerror("ERROR LEXICO - Constante entera mal formada"); return YYerror;}
{fraccion}{exponencial}?|{digito}+{exponencial}                 {sscanf(yytext, "%lf", &yylval.num); return REAL;}
{fraccion}{error_real}+({digito}|{letra}|{invalido})*           {yyerror("ERROR LEXICO - Constante real mal formada"); return YYerror;}
{letra}({letra}|{digito})*                                      {yylval.cadena = strdup(yytext); return IDENTIFICADOR;}
{letra}({letra}|{digito}|{invalido})*                           {yyerror("ERROR LEXICO - Identificador mal formado"); return YYerror;}
\n                                                              {yylval.cadena = strdup(yytext); return '\n';}
{invalido}+                                                     {yyerror("ERROR LEXICO - Cadena invalida"); return YYerror;}
.                                                               ;

%%