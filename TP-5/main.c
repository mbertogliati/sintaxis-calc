#include "scanner.h"
#include "parser.h"

char *token_names[] = {"EOF", "Entero", "Real", "Identificador", "Operador de asignacion", "Operador aritmetico", "NL", "Parentesis", "SALIR", "CTE", "VAR"};
int main(void) {

	while(1){
		yyparse();
	}
	return 0;
}