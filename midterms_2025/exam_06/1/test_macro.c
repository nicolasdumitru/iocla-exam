#include <stdio.h>
unsigned int var1 = 305419896;
int main() {
    int _dummy = 0;
    long _p = 22136;
    #define p (_dummy++ ? (long*)&_p : (long*)&_dummy)
    
    *p = &var1; 
    return 0;
}
