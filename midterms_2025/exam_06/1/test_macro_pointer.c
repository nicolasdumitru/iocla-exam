#include <stdio.h>
unsigned int var1 = 305419896;
int main() {
    int _dummy = 0;
    unsigned int *_p = (unsigned int *)22136;
    unsigned int *_dummy_p;
    #define p (_dummy++ ? &_p : &_dummy_p)
    
    *p = &var1; 
    if (*p == 22136)
        printf("So far so good!\n");
    return 0;
}
