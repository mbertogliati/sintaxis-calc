%code top{
    #include <stdio.h>
    #include "scanner.h"
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
%right <cadena> OP_ASIG 

%token '('
%token ')'
%token <entero> ENTERO 
%token <real> REAL 
%token <cadena> IDENTIFICADOR
%token <cadena> SALIR 
%token <cadena> CTE
%token <cadena> VAR
%token <cadena> FDT 

%defines "parser.h"
%output "parser.c"


%%

programa: 
          sentencia 
        | %empty;
        
sentencia: 
          expresion 
        | declaracion 
        | SALIR;
        
declaracion:
          CTE IDENTIFICADOR inicializacion {printf("Define ID como Constante");}
        | VAR IDENTIFICADOR inicializacion {printf("Define ID como Variable e inicializa");}
        | VAR IDENTIFICADOR {printf("Define ID como Variable sin inicializar");};

inicializacion:
          '=' expresion;

expresion:
          asignacion
        | expresion-aditiva;

asignacion:
          IDENTIFICADOR OP_ASIG expresion;

expresion-aditiva:
          expresion-multiplicativa
        | expresion '+' expresion-multiplicativa {printf("Suma");}
        | expresion '-' expresion-multiplicativa {printf("Resta");};

expresion-multiplicativa:
          expresion-unaria
        | expresion-multiplicativa '*' expresion-unaria {printf("Multiplicacion");}
        | expresion-multiplicativa '/' expresion-unaria {printf("Division");};

expresion-unaria:
          expresion-exponenciacion
          '-'expresion-exponenciacion %prec NEG {printf("Menos unario");}; 

expresion-exponenciacion:
          valor
        | valor '^' expresion-exponenciacion {printf("Exponenciacion");};

valor:
          ENTERO {printf("Entero");}
        | REAL {printf("Real");}
        | IDENTIFICADOR {printf("ID");}
        | '('expresion')'
        | IDENTIFICADOR'('expresion')'{printf("Funcion");};



%%
void yyerror(const char *s){
	printf("línea #%d: %s", yylineno, s);
	return;
}