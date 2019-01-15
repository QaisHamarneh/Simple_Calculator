#include <stdio.h>
#include <stdlib.h>

#include "header.h"
table_t *symTable;

table_t * createTable(int size){
    table_t *t = (struct table*)malloc(sizeof(struct table));
    t->size = size;
    t->list = (struct node**)malloc(sizeof(struct node*)*size);
    int i;
    for(i=0 ; i<size ; i++)
        t->list[i] = NULL;
    return t;
}

void initTable(void)
{
    symTable = createTable(64);
}

long hashCode(char * key) {
  long sum = 0;
  for (int j = 0; j < strlen(key); j++) {
      sum += key[j];
  }

  return(sum % symTable->size);
}


void insert(char * key,double val){
    int pos = hashCode(key);
    node_t *list = symTable->list[pos];
    node_t *newNode = (struct node*)malloc(sizeof(struct node));
    node_t *temp = list;
    while(temp){
        if(strcmp(temp->key, key) == 0){
            temp->value = val;
            return;
        }
        temp = temp->next;
    }
    strcpy(newNode->key, key);
    newNode->value = val;
    newNode->next = list;
    symTable->list[pos] = newNode;
}

double lookup(char * key){
    int pos = hashCode(key);
    node_t *list = symTable->list[pos];
    node_t *temp = list;
    while(temp){
        if(strcmp(temp->key, key) == 0){
            return temp->value;
        }
        temp = temp->next;
    }
    return 0;
}
