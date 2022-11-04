#include "scanner.c"

char *token_names[] = {"EOF", "Entero", "Real", "Identificador", "Operador de asignacion", "Operador aritmetico", "NL", "Parentesis", "SALIR", "CTE", "VAR"};
int main() {
	enum token t;

	while ((t = yylex()) != FDT){
		if(t > NL) //Si es parentesis, salir, cte o var
			printf("Token: %s\n",yytext); 
		else if (t == NL) //Si es NL
			printf("Token: '%s'\n",token_names[t]);
		else if(yyleng == 1){ //Si no es NL, parentesis, salir, cte o var, y es de largo 1
				printf("Token: %s\t\tLexema: '%c'\n",token_names[t],yytext[0]); //Si es 1, se muestra como char
			}
			else{ //Si su largo es mayor a 1, se muestra como cadena de caracteres
				printf("Token: %s\t\tLexema: %s\n",token_names[t], yytext);
			}		
	}

	printf("Token: Fin de Archivo");

	return 0;
}