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
    extern char resultado[];
}
%union{
    int entero;
    double num;
    char *cadena;
}

%right '=' "+=" OP_ASIG_SUMA "-=" OP_ASIG_RESTA "*=" OP_ASIG_MULT "/=" OP_ASIG_DIV
%left '+' '-'
%left '*' '/'
%precedence NEG
%left '^'


%token YYEOF
%token '('
%token ')'
%token <num> ENTERO 
%token <num> REAL 
%token <cadena> IDENTIFICADOR
%token <cadena> FUNCION
%token <cadena> SALIR 
%token <cadena> CTE
%token <cadena> VAR


%defines "parser.h"
%output "parser.c"
%define parse.error verbose

%type<num> valor expresion-aritmetica asignacion expresion
%type<cadena> declaracion sentencia


%%

programa: 
          linea
        | programa linea
        ;

linea:
          sentencia '\n' {printf("%s",$sentencia);}
        | sentencia YYEOF {printf("%s",$sentencia); return SALIR;}
        | '\n' {puts("");}
        | error '\n' {YYABORT;}
        ;
        
sentencia:
          expresion {sprintf(resultado,"> %g\n", $expresion); $$ = resultado;}
        | declaracion {$$="";}
        | SALIR { $$="";return SALIR;}
        ;
        
declaracion:
          CTE IDENTIFICADOR '=' expresion {if (estaDeclarado($IDENTIFICADOR)) YYERROR; agregar_simbolo($IDENTIFICADOR,CTE); modificar_valor($IDENTIFICADOR, $expresion); printf("> %s: %g\n", buscar_simbolo($IDENTIFICADOR)->nombre, valor($IDENTIFICADOR)); $$="";}
        | VAR IDENTIFICADOR '=' expresion {if (estaDeclarado($IDENTIFICADOR)) YYERROR; agregar_simbolo($IDENTIFICADOR,VAR); modificar_valor($IDENTIFICADOR, $expresion); printf("> %s: %g\n", buscar_simbolo($IDENTIFICADOR)->nombre, valor($IDENTIFICADOR));$$="";}
        | VAR IDENTIFICADOR {if (estaDeclarado($IDENTIFICADOR)) YYERROR; agregar_simbolo($IDENTIFICADOR,VAR); printf("> Se declaro '%s' sin inicializar.\n", buscar_simbolo($IDENTIFICADOR)->nombre);$$="";}
        ;

expresion:
          asignacion
          | expresion-aritmetica
          ;
asignacion:
        IDENTIFICADOR '=' expresion {if(noEstaDeclarado($IDENTIFICADOR) || esCte($IDENTIFICADOR))YYERROR; modificar_valor($IDENTIFICADOR, $3); $$ = $3;}
        | IDENTIFICADOR OP_ASIG_SUMA expresion {if (noEstaInicializado($IDENTIFICADOR) || esCte($IDENTIFICADOR)) YYERROR; modificar_valor($IDENTIFICADOR, valor($IDENTIFICADOR)+$3); $$ = valor($IDENTIFICADOR); }
        | IDENTIFICADOR OP_ASIG_RESTA expresion {if (noEstaInicializado($IDENTIFICADOR) || esCte($IDENTIFICADOR)) YYERROR; modificar_valor($IDENTIFICADOR, valor($IDENTIFICADOR)-$3); $$ = valor($IDENTIFICADOR); }
        | IDENTIFICADOR OP_ASIG_MULT expresion {if (noEstaInicializado($IDENTIFICADOR) || esCte($IDENTIFICADOR)) YYERROR; modificar_valor($IDENTIFICADOR, valor($IDENTIFICADOR)*$3); $$ = valor($IDENTIFICADOR); }
        | IDENTIFICADOR OP_ASIG_DIV expresion {if (noEstaInicializado($IDENTIFICADOR) || esCte($IDENTIFICADOR)) YYERROR; modificar_valor($IDENTIFICADOR, valor($IDENTIFICADOR)/$3); $$ = valor($IDENTIFICADOR); }
        ;
expresion-aritmetica:
        expresion-aritmetica '+' expresion-aritmetica {$$ = $1 + $3;}
        | expresion-aritmetica '-' expresion-aritmetica {$$ = $1 - $3;}
        | expresion-aritmetica '*' expresion-aritmetica {$$ = $1 * $3;}
        | expresion-aritmetica '/' expresion-aritmetica {$$ = $1 / $3;}
        | '-'expresion-aritmetica %prec NEG {$$ = -$2;}
        | valor '^' expresion-aritmetica {$$ = pow($valor, $3);}
        | valor {$$ = $valor;}
        ;

valor:
          ENTERO {$valor = $ENTERO;}
        | REAL {$valor = $REAL;}
        | IDENTIFICADOR {if(noEstaInicializado($IDENTIFICADOR)) YYERROR; $valor = valor($IDENTIFICADOR);}
        | '('expresion')'{$valor = $expresion;}
        | FUNCION'('expresion')'{ $valor = aplicarFuncion($FUNCION, $expresion);}
        ;

%%
char resultado[100];

void yyerror(const char *s){
	printf("> %s\n",s);
}
