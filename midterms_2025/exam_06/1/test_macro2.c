#include <stdio.h>
unsigned int var1 = 305419896;
int main() {
    unsigned int **p;
    unsigned int *dummy_ptr;
    p = &dummy_ptr;
    #define var1 (*(unsigned int**)22136)
    
    *p = &var1; 
    if (*p == (unsigned int*)22136) // Wait, the code has: if (*p == 22136)
        printf("So far so good!\n");
    return 0;
}
