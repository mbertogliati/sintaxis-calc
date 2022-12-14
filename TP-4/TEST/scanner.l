%{
#include <stdio.h>
#include "parser.h"
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

salir                                                           {return SALIR;}
var                                                             {return VAR;}
cte                                                             {return CTE;}
\+                                                              {return '+';}
-                                                               {return '-';}
\*                                                              {return '*';}
\/                                                              {return '/';}
\^                                                              {return '^';}
\(                                                              {return '(';}
\)                                                              {return ')';}
=|\+=|-=|\*=|=                                                  {return OP_ASIG;}

{digito}+                                                       {return ENTERO;}
{digito}({digito}|{letra})+                                     {printf("ERROR LEXICO - Constante entera mal formada");}
{fraccion}{exponencial}?|{digito}+{exponencial}                 {return REAL;}
{fraccion}{error_real}+({digito}|{letra}|{invalido})*           {printf("ERROR LEXICO - Constante real mal formada");}
{letra}({letra}|{digito})*                                      {return IDENTIFICADOR;}
{letra}({letra}|{digito}|{invalido})*                           {printf("ERROR LEXICO - Identificador mal formado");}
\n                                                              {return '\n';}
{invalido}+                                                     {printf("ERROR LEXICO - Cadena invalida");}
.                                                               ;

%%