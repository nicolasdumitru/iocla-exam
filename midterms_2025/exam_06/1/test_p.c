#include <stdio.h>
unsigned int var1 = 305419896;
int main() {
    int dummy = 22136;
    int *p_ptr = &dummy;
    #define p p_ptr
    
    *p = &var1;
    if (*p == 22136) {
        printf("So far so good!\n");
    }
    return 0;
}
