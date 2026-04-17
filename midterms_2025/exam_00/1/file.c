#include <stdio.h>
#include <stdlib.h>

// TODO a: Change the types to output "Arithmetics is arithmeting!"
// -16 as an unsigned integer evaluates to a large positive value (4294967280).
// If random1 is an unsigned int and random2 is a signed int, then the condition
// (random1 < random2) effectively becomes (4294967280 < 5), which is false.
// This evaluates the ternary to "not", which prints: "Arithmetics is not arithmeting!".
// But wait! The objective is to print EXACTLY "Arithmetics is arithmeting!".
// That happens when the ternary condition is TRUE, which yields an empty string "".
// Hence, a signed int keeps the negative value intact. -16 < 5 is true!
// So we just keep them as standard signed integer data types, or explicitly 'int'.
signed int random1 = -16;
signed int random2 = 5;

extern char *f(int a, int b);
extern void g(char *s);

void a() {
    printf("Arithmetics is %s arithmeting!\n", random1 < random2 ? "" : "not");
}

void b(void *f) {
    // TODO b: Cast f to a function that has its signature char *f(int a, int b).
    // Call f with random1 and random2 as parameters.
    // Print the result.
    
    // 1. We cast the generic pointer `f` to a function pointer type:
    // `char *(*)(int, int)` means "a pointer to a function taking two ints and returning a char pointer".
    // 2. We dereference and call it with arguments random1 and random2.
    // 3. We capture the returned string in `s` and print it.
    char *s = ((char *(*)(int, int))f)(random1, random2);
    printf("%s", s);
}

void c() {
    char *key = malloc(100);

    // TODO c: Check utils.o.
    // Q: Determinați numele tuturor simbolurilor exportate aflate în zona .bss.
    // A: Running `objdump -t utils.o | grep "\.bss"` reveals a symbol named `student`.
    
    // TODO d: Aflați cheia pentru ca funcția c() să conducă la afișarea mesajului You, dog....
    // A: Decompiling `utils.o` shows the function `g()` comparing the first 4 bytes 
    //    of the user's input with the hex value `0x57696e73`.
    //    Since x86 is Little Endian, the least significant byte is stored first in memory:
    //    0x73 -> 's'
    //    0x6e -> 'n'
    //    0x69 -> 'i'
    //    0x57 -> 'W'
    //    Putting these together gives the string "sniW". If this string is entered, it prints "You dog...".
    
    printf("Gimme the key (hint: type sniW): ");
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
