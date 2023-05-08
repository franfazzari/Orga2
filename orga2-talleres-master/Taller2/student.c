#include "student.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>


void printStudent(student_t *stud)
{
    /* Imprime por consola una estructura de tipo student_t
    */
    printf("Nombre: %s \ndni: %i\n", stud->name, stud->dni);
    printf("Calificaciones: %i,%i,%i\n", stud->califications[0],stud->califications[1],stud->califications[2]);
    printf("Concepto: %i\n",stud->concept);
    printf("--------\n");

}

void printStudentp(studentp_t *stud)
{
    /* Imprime por consola una estructura de tipo studentp_t
    */
    printf("Nombre: %s\ndni: %i\n", stud->name, stud->dni);
    printf("Calificaciones: %i,%i,%i\n", stud->califications[0],stud->califications[1],stud->califications[2]);
    printf("Concepto: %i\n",stud->concept);
    printf("--------\n");

}
