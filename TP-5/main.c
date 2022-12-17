#include "scanner.h"
#include "parser.h"
#include "calc.h"


//Matias Nahuel Cotens Legajo: 202682-0
//Guadalupe García
//Mateo Bertogliati Legajo: 203413-0

char *token_names[] = {"EOF", "Entero", "Real", "Identificador", "Operador de asignacion", "Operador aritmetico", "NL", "Parentesis", "SALIR", "CTE", "VAR"};
int main(void) {
	agregar_constantes();
	while(yyparse() != SALIR){
		//yylex_destroy();
	}

	return 0;
}