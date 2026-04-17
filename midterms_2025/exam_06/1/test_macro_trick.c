#include <stdio.h>
unsigned int var1 = 305419896;

int main() {
    int _dummy = 0;
    long _garbage;
    #define p (_dummy++ ? (short*)&var1 : (short*)&_garbage)

    *p = &var1;

    if (*p == 22136)
        printf("So far so good!\n");

    return 0;
}
