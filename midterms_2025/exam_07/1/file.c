#include <stdio.h>

// TODO 1: Minimize the size of the struct s by reordering the fields
struct s{
	// Minimizing struct size by ordering fields from largest alignment requirement to smallest.
	int b;       // 4 bytes
	int d;       // 4 bytes
	short e;     // 2 bytes
	short g;     // 2 bytes
	char c[5];   // 5 bytes
	char a;      // 1 byte
	char f;      // 1 byte
	char h;      // 1 byte
};

// DO NOT MODIFY BEGINS
void g();
void h();
void finish();

unsigned a = 0;

void *ptrs[] = {g, h, finish};

void g()
{
	int func_idx;

	a++;
	scanf("%d", &func_idx);
	((void (*)())ptrs[func_idx])();
}

void h()
{
	int func_idx;

	a--;
	scanf("%d", &func_idx); 
	((void (*)())ptrs[func_idx])();

}

void finish()
{
	if (a == ~(unsigned)0)
		printf("You get a cookie!\n");
	else
		printf("No cookie for you!\n");
}

// DO NOT MODIFY ENDS

// TODO 2: Declare a variable in .rodata with an unexported symbol
// Using `static const` ensures placement in `.rodata` and no external symbol linkage.
static const int my_var = 42;
int main()
{
	printf("Size of struct s: %u\n", sizeof(struct s));

	// TODO 3: Give the correct input such that the program prints "You get a cookie!"
	// A: We need the counter `a` to reach `~(unsigned)0` which is `-1`. 
	// At start, `a = 0`. So we need to execute just `a--`.  
	// `h()` decrements `a`. `finish()` checks the result. 
	// `ptrs[1]` is `h`, `ptrs[2]` is `finish`.
	// Therefore, providing input `1` (which calls `h`), then `2` (which calls `finish`) 
	// is the correct sequence.
	int func_selector;
	scanf("%d", &func_selector);

	((void (*)())ptrs[func_selector])();
}
