#include "scanner.h"
#include "parser.h"
#include "calc.h"

char *token_names[] = {"EOF", "Entero", "Real", "Identificador", "Operador de asignacion", "Operador aritmetico", "NL", "Parentesis", "SALIR", "CTE", "VAR"};
int main(void) {
	agregar_constantes();

	while(1){
		if(yyparse() == 4) return 0;
	}

	return 0;
}