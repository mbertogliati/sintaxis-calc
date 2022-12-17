#include "scanner.h"
#include "parser.h"
#include "calc.h"

char *token_names[] = {"EOF", "Entero", "Real", "Identificador", "Operador de asignacion", "Operador aritmetico", "NL", "Parentesis", "SALIR", "CTE", "VAR"};
int main(void) {
	agregar_constantes();
	while(yyparse() != SALIR){
		//yylex_destroy();
	}

	return 0;
}