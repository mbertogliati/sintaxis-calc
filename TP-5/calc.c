#include "calc.h"
#include <stdio.h>
simbolo* ultima_busqueda;

simbolo *tabla_de_simbolos = NULL;

simbolo *buscar_simbolo (char const *name){

    simbolo* actual = tabla_de_simbolos;

    while(actual != NULL){
        if(strcmp(actual->nombre, name) == 0)
            return actual;
        actual = actual->sgte;
    }
    return NULL;

}

simbolo *agregar_simbolo (char *name, int tipo){

    simbolo* nuevo_simbolo = malloc(sizeof(simbolo));
    nuevo_simbolo->nombre = name;
    nuevo_simbolo->tipo = tipo;
    nuevo_simbolo->estaInicializado = false;

    if(tabla_de_simbolos == NULL){
        tabla_de_simbolos = nuevo_simbolo;
        return tabla_de_simbolos;
    }

    simbolo* actual = tabla_de_simbolos;

    while(actual->sgte != NULL)
        actual = actual->sgte;
    
    actual->sgte = nuevo_simbolo;
    return nuevo_simbolo;
}

simbolo *modificar_valor(char const *name, double nuevo_valor){
    simbolo *buscado = buscar_simbolo(name);
    if(buscado != NULL){
        if(buscado->estaInicializado && buscado->tipo == CTE){

            char mensaje[100];
            sprintf(mensaje,"ERROR SEMANTICO - '%s' es constante y no se puede modificar", name);
            yyerror(mensaje);
            
        }
        else{
            buscado->valor = nuevo_valor;
            buscado->estaInicializado = true;
        }
            

    }

    return buscado;
}
double valor(char* name){
    simbolo *sym = buscar_simbolo(name);
    
    return sym->valor;
}

bool estaDeclarado(char *name){
    if( (ultima_busqueda = buscar_simbolo(name) ) != NULL){
        char mensaje[100];
        sprintf(mensaje, "ERROR SEMANTICO - '%s' ya esta declarado", name);
        yyerror(mensaje);
        return true;
    }
    else
        return false;
}

bool noEstaDeclarado(char *name){
    if( (ultima_busqueda = buscar_simbolo(name) ) == NULL){
        char mensaje[100];
        sprintf(mensaje,"ERROR SEMANTICO - '%s' no esta declarado", name);
        yyerror(mensaje);
        return true;
    }
    else
        return false;
}

bool estaInicializado(char *name){
    
    if(noEstaDeclarado(name))
        return false;
    
    else{
        if(ultima_busqueda->estaInicializado)
            return true;
        
        else{
            char mensaje[100];
            sprintf(mensaje,"ERROR SEMANTICO - '%s' no esta inicializado", name);
            yyerror(mensaje);
            
            return false;
        }
    }
}
