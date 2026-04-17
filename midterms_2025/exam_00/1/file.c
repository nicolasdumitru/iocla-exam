#include <stdio.h>
#include <stdlib.h>

// TODO a
int random1 = -16;
int random2 = 5;

extern char *f(int a, int b);
extern void g(char *s);

void a() {
    printf("Arithmetics is %s arithmeting!\n", random1 < random2 ? "" : "not");
}

void b(void *f) {
    // TODO b: Cast f to a function that has its signature char *f(int a, int b).
    // Call f with random1 and random2 as parameters.
    // Print the result.
    char *s = ((char *(*)(int, int))f)(random1, random2);
    printf("%s", s);
}

void c() {
    char *key = malloc(100);

    // TODO c: Check utils.o.
    printf("Gimme the key: ");
    fgets(key, 100, stdin);
    g(key);

    free(key);
}

int main(void) {
    a();
    b((void *)f);
    c();
    return 0;
}
