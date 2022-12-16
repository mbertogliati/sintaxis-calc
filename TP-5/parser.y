%code top{
    #include <stdio.h>
    #include "scanner.h"
    #include <string.h>
    #include "calc.h"
    #include <math.h>
}
%code provides {
    void yyerror(const char *s);
    extern int nerrlex;
}
%union{
    int entero;
    double num;
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
%token <num> ENTERO 
%token <num> REAL 
%token <cadena> IDENTIFICADOR
%token <cadena> SALIR 
%token <cadena> CTE
%token <cadena> VAR

%defines "parser.h"
%output "parser.c"
%define parse.error verbose

%type<num> valor expresion-exponenciacion expresion-unaria expresion-multiplicativa expresion-aditiva expresion asignacion inicializacion sentencia


%%

programa: 
          linea
        | programa '\n' {{printf("\n");}}linea
        ;

linea:
        
          sentencia {printf("%lf\n", $sentencia);}
        | declaracion
        | %empty
        ;
        
sentencia: 
          expresion {$$ = $1;}
        | SALIR {printf("Fin del programa\n"); return 0;}
        ;
        
declaracion:
          CTE IDENTIFICADOR inicializacion {if (estaDeclarado($IDENTIFICADOR)) YYABORT; agregar_simbolo($IDENTIFICADOR,CTE); modificar_valor($IDENTIFICADOR, $inicializacion); printf("%s: %lf\n", buscar_simbolo($IDENTIFICADOR)->nombre, valor($IDENTIFICADOR));}
        | VAR IDENTIFICADOR inicializacion {if (estaDeclarado($IDENTIFICADOR)) YYABORT; agregar_simbolo($IDENTIFICADOR,VAR); modificar_valor($IDENTIFICADOR, $inicializacion); printf("%s: %lf\n", buscar_simbolo($IDENTIFICADOR)->nombre, valor($IDENTIFICADOR));}
        | VAR IDENTIFICADOR {if (estaDeclarado($IDENTIFICADOR)) YYABORT; agregar_simbolo($IDENTIFICADOR,VAR); printf("Se declaro '%s' sin inicializar.\n", buscar_simbolo($IDENTIFICADOR)->nombre);}
        ;

inicializacion:
          '=' expresion {$$ = $expresion;}
          ;

expresion:
          asignacion {$$ = $1;}
        | expresion-aditiva {$$ = $1;}
        ;

asignacion:
          IDENTIFICADOR '=' expresion {if(noEstaDeclarado($IDENTIFICADOR)) YYABORT; modificar_valor($IDENTIFICADOR, $expresion); $$ = $expresion;}
        | IDENTIFICADOR OP_ASIG_SUMA expresion {if (!estaInicializado($IDENTIFICADOR)) YYABORT; modificar_valor($IDENTIFICADOR, valor($IDENTIFICADOR)+$expresion); $$ = valor($IDENTIFICADOR); }
        | IDENTIFICADOR OP_ASIG_RESTA expresion {if (!estaInicializado($IDENTIFICADOR)) YYABORT; modificar_valor($IDENTIFICADOR, valor($IDENTIFICADOR)-$expresion); $$ = valor($IDENTIFICADOR); }
        | IDENTIFICADOR OP_ASIG_MULT expresion {if (!estaInicializado($IDENTIFICADOR)) YYABORT; modificar_valor($IDENTIFICADOR, valor($IDENTIFICADOR)*$expresion); $$ = valor($IDENTIFICADOR); }
        | IDENTIFICADOR OP_ASIG_DIV expresion {if (!estaInicializado($IDENTIFICADOR)) YYABORT; modificar_valor($IDENTIFICADOR, valor($IDENTIFICADOR)/$expresion); $$ = valor($IDENTIFICADOR); }
        ;

expresion-aditiva:
          expresion-multiplicativa {$$ = $1;}
        | expresion-aditiva '+' expresion-multiplicativa {$$ = $1 + $3;}
        | expresion-aditiva '-' expresion-multiplicativa {$$ = $1 - $3;}
        ;

expresion-multiplicativa:
          expresion-unaria {$$ = $1;}
        | expresion-multiplicativa '*' expresion-unaria {$$ = $1 * $3;}
        | expresion-multiplicativa '/' expresion-unaria {$$ = $1 / $3;}
        ;

expresion-unaria:
          expresion-exponenciacion {$$ = $1;}
        | '-'expresion-exponenciacion %prec NEG {$$ = -$2;}
        ; 

expresion-exponenciacion:
          valor {$$ = $valor;}
        | valor '^' expresion-exponenciacion {$$ = pow($valor, $3);}
        ;

valor:
          ENTERO {$valor = $ENTERO;}
        | REAL {$valor = $REAL;}
        | IDENTIFICADOR {if(!estaInicializado($IDENTIFICADOR)) YYABORT; $valor = valor($IDENTIFICADOR);}
        | '('expresion')'{$valor = $expresion;}
        | IDENTIFICADOR'('expresion')'{printf("Funcion\n");}
        ;



%%
void yyerror(const char *s){
	printf("%s\n",s);
	return;
}