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

%left '+' '-'
%left '*' '/'
%precedence NEG
%left '^'
%right '='
%right "+=" OP_ASIG_SUMA "-=" OP_ASIG_RESTA
%right "*=" OP_ASIG_MULT "/=" OP_ASIG_DIV


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

%type<num> valor expresion-exponenciacion expresion-unaria expresion-multiplicativa expresion-aditiva expresion asignacion
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
          asignacion {$$ = $1;}
        | expresion-aditiva {$$ = $1;}
        ;

asignacion:
          IDENTIFICADOR '=' expresion {if(noEstaDeclarado($IDENTIFICADOR) || esCte($IDENTIFICADOR))YYERROR; modificar_valor($IDENTIFICADOR, $expresion); $$ = $expresion;}
        | IDENTIFICADOR OP_ASIG_SUMA expresion {if (noEstaInicializado($IDENTIFICADOR) || esCte($IDENTIFICADOR)) YYERROR; modificar_valor($IDENTIFICADOR, valor($IDENTIFICADOR)+$expresion); $$ = valor($IDENTIFICADOR); }
        | IDENTIFICADOR OP_ASIG_RESTA expresion {if (noEstaInicializado($IDENTIFICADOR) || esCte($IDENTIFICADOR)) YYERROR; modificar_valor($IDENTIFICADOR, valor($IDENTIFICADOR)-$expresion); $$ = valor($IDENTIFICADOR); }
        | IDENTIFICADOR OP_ASIG_MULT expresion {if (noEstaInicializado($IDENTIFICADOR) || esCte($IDENTIFICADOR)) YYERROR; modificar_valor($IDENTIFICADOR, valor($IDENTIFICADOR)*$expresion); $$ = valor($IDENTIFICADOR); }
        | IDENTIFICADOR OP_ASIG_DIV expresion {if (noEstaInicializado($IDENTIFICADOR) || esCte($IDENTIFICADOR)) YYERROR; modificar_valor($IDENTIFICADOR, valor($IDENTIFICADOR)/$expresion); $$ = valor($IDENTIFICADOR); }
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
        | IDENTIFICADOR {if(noEstaInicializado($IDENTIFICADOR)) YYERROR; $valor = valor($IDENTIFICADOR);}
        | '('expresion')'{$valor = $expresion;}
        | FUNCION'('expresion')'{ $valor = aplicarFuncion($FUNCION, $expresion);}
        ;

%%
char resultado[100];

void yyerror(const char *s){
	printf("> %s\n",s);
}
