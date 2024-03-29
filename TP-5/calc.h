#ifndef calc_h
#define calc_h

#include "parser.h"
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

typedef union valores{
        double real; //Para revisar
        int entero;
    } valores; 

typedef struct simbolo{
    char *nombre;
    int tipo; //CTE o VAR
    bool estaInicializado;
    double valor;
    struct simbolo *sgte;
}simbolo;

extern simbolo *tabla_de_simbolos;

extern int errores;

void agregar_constantes(void);
simbolo *agregar_simbolo (char *name, int tipo);
simbolo *buscar_simbolo (char const *name);
simbolo *modificar_valor(char const *name, double nuevo_valor);

double valor(char* name);
bool estaDeclarado(char* name);
bool noEstaDeclarado(char* name);
bool estaInicializado(char* name);
bool esFuncion(char *funcion);
double aplicarFuncion(char *funcion, double valor);
bool esCte(char *name);
bool noEstaInicializado(char *name);

#endif