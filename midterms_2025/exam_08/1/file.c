#include <stdio.h>
#include <string.h>

extern void a();
extern void b();
extern char **p;

int def_count(char **p)
{
    /**
     * TODO a: Din -123 ajungem la 123 in overflow citit ca %hd matematic astfel:
     * Daca adunam 246 => -123 + 246 = 123.
     * De la stdin, valoarea asteptata este "246".
     *
     * TODO c: Folosind objdump si struct student_t, calculam offset-ul age (0x18).
     * La acel offset in sectiunea .data gasim 0x0015. 
     * Asadar, campul age contine valoarea 21.
     * 
     * TODO d: Simbolurile neexportate aflate in .bss din ierarhia my-hierarchy sunt
     * din fisierul ops.h: "no_ops" si "ops". (Sunt singurele static din ierarhie 
     * initializate implicit in .bss).
     *
     * TODO b: Dereference p until it contains the `STOP` string
     * Return the number of dereferences
     */
    int count = 0;
    char *s = (char*)p;
    while (strcmp(s, "STOP") != 0) {
        s = *(char**)s;
        count++;
    }
    return count;
}

int main(void)
{
    a();
    b();
    return 0;
}
