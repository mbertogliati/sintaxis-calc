#include "scanner.c"

char *token_names[] = {"", "ENTERO", "REAL", "IDENTIFICADOR", "OPERADOR DE ASIGNACION", "OPERADOR ARITMETICO", "INSTRUCCION", "NL", "PARENTESIS"};
int main() {
	enum token t;
	while ((t = yylex()) != FDT){
		if(t == NL){
            //printf("Token: %s\t\n", token_names[t]);
        }
        else
			printf("Token: %s\t\tValor: %s\n", token_names[t], yytext);
	}
	return 0;
}