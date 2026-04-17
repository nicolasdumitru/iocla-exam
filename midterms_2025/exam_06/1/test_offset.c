#include <stdio.h>
unsigned int var1 = 305419896;
unsigned int var2 = 0xdeadbeef;
unsigned int v1[] = {1, 2, 3, 4, 5, 6, 7, 8};
unsigned int v2[] = {1, 2, 3, 4, 5, 6, 7, 8};
int main() {
    printf("%ld\n", (long)(&v2[0] - &var2));
    return 0;
}
