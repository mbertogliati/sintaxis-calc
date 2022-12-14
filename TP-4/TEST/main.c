#include "scanner.h"
#include "parser.h"

char *token_names[] = {"EOF", "Entero", "Real", "Identificador", "Operador de asignacion", "Operador aritmetico", "NL", "Parentesis", "SALIR", "CTE", "VAR"};
int main() {
	
	enum yytokentype t;
	while ((t = yylex()) != YYEOF){
		printf("Token: %d - Lexema: %s\n",t,yytext); 	
	}
}