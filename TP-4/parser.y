%code top{
    #include <stdio.h>
    #include "scanner.h"
    #include <string.h>
}
%code provides {
    void yyerror(const char *s);
    extern int nerrlex;
}
%union{
    int entero;
    double real;
    char *cadena;
}

%left '+' '-'
%left '*' '/'
%precedence NEG
%left '^'
%right '='
%right "+=" OP_ASIG_SUMA "-=" OP_ASIG_RESTA
%right "*=" OP_ASIG_MULT "/=" OP_ASIG_DIV

%token '('
%token ')'
%token <entero> ENTERO 
%token <real> REAL 
%token <cadena> IDENTIFICADOR
%token <cadena> SALIR 
%token <cadena> CTE
%token <cadena> VAR

%defines "parser.h"
%output "parser.c"
%define parse.error verbose

%%

programa: 
          linea
        | programa '\n' {{printf("\n");}}linea
        ;

linea:
        
          sentencia
        | error
        | %empty
        ;
        
sentencia: 
          expresion {printf("Expresion\n");}
        | declaracion
        | SALIR {printf("Fin del programa\n");}
        ;
        
declaracion:
          CTE IDENTIFICADOR inicializacion {printf("Define ID como Constante \n");}
        | VAR IDENTIFICADOR inicializacion {printf("Define ID como Variable e inicializa\n");}
        | VAR IDENTIFICADOR {printf("Define ID como Variable sin inicializar\n");}
        ;

inicializacion:
          '=' expresion
          ;

expresion:
          asignacion
        | expresion-aditiva
        ;

asignacion:
          IDENTIFICADOR '=' expresion {printf("Asignacion\n");}
        | IDENTIFICADOR OP_ASIG_SUMA expresion {printf("Asignacion con Suma\n");}
        | IDENTIFICADOR OP_ASIG_RESTA expresion {printf("Asignacion con Resta\n");}
        | IDENTIFICADOR OP_ASIG_MULT expresion {printf("Asignacion con Multiplicacion\n");}
        | IDENTIFICADOR OP_ASIG_DIV expresion {printf("Asignacion con Division\n");}
        ;

expresion-aditiva:
          expresion-multiplicativa
        | expresion-aditiva '+' expresion-multiplicativa {printf("Suma\n");}
        | expresion-aditiva '-' expresion-multiplicativa {printf("Resta\n");}
        ;

expresion-multiplicativa:
          expresion-unaria
        | expresion-multiplicativa '*' expresion-unaria {printf("Multiplicacion\n");}
        | expresion-multiplicativa '/' expresion-unaria {printf("Division\n");}
        ;

expresion-unaria:
          expresion-exponenciacion 
        | '-'expresion-exponenciacion %prec NEG {printf("Menos unario\n");}
        ; 

expresion-exponenciacion:
          valor
        | valor '^' expresion-exponenciacion {printf("Exponenciacion\n");}
        ;

valor:
          ENTERO {printf("Entero\n");}
        | REAL {printf("Real\n");}
        | IDENTIFICADOR {printf("ID \n");}
        | '('expresion')'
        | IDENTIFICADOR'('expresion')'{printf("Funcion\n");}
        ;



%%
void yyerror(const char *s){
	printf("\nERROR - línea #%d: %s\n", yylineno, s);
	return;
}