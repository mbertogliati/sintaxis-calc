%{
#include <stdio.h>
#include "tokens.h"
%}

%option header-file="scanner.h"
%option outfile="scanner.c"
%option noinput
%option nounput

digito  [0-9]
letra [A-Za-z]
exponencial [eE][+-]?{digito}+
fraccion {digito}*\.{digito}+|{digito}+\.

%%

salir|var|cte                                           return INSTRUCCION;
{digito}+                                               return ENTERO;
{fraccion}{exponencial}?|{digito}+{exponencial}         return REAL;
{letra}([{letra}{digito}]*)                             return IDENTIFICADOR;
=|\+=|-=|\*=|=                                          return OP_ASIG;
\+|-|\*|\/|^                                            return OP_ARIT;
\(|\)                                                   return PAR;
{digito}+{letra}+[{digito}{letra}]*                     printf("ERROR LEXICO - Constante entera mal formada: %s\n", yytext);
{fraccion}{exponencial}?\.[{exponencial}{digito}{letra}\.]*    printf("ERROR LEXICO - Constante real mal formada: %s\n", yytext);
{letra}+([.]{-}[{digito}{letra}])+([.])*                printf("ERROR LEXICO - Identificador mal formado: %s\n", yytext);
[.]{-}[{digito}{letra}]+[.]*                            printf("ERROR LEXICO - Cadena invalida: %s\n", yytext);
\n                                                      return NL;
.                                                       ;

%%

//[^{digito}{letra}]+                                     printf("ERROR LEXICO - Cadena invalida: %s\n", yytext);

//flex scanner.l
//gcc -g -Wall scanner.c main.c -o scantest -lfl
//./scantest <entrada.txt >salida.txt