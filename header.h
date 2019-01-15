#ifndef SYMTABLE_H
#define SYMTABLE_H

#define VARIABLE_NAME_SIZE  32
#include <stdbool.h>
#include <string.h>

typedef struct node{
    char key[VARIABLE_NAME_SIZE];
    double value;
    struct node *next;
}node_t;

typedef struct table{
    int size;
    struct node **list;
}table_t;


extern table_t * createTable(int size);
extern void insert(char * key,double val);
extern node_t * lookup(char * key);

extern table_t *symTable;

extern int doubleCount;

extern void initTable(void);

#endif 
