#include <stdio.h>

/* DO NOT MODIFY */

unsigned int var1 = 305419896;
unsigned int var2 = 0xdeadbeef;
unsigned int v1[] = {1, 2, 3, 4, 5, 6, 7, 8};
unsigned int v2[] = {1, 2, 3, 4, 5, 6, 7, 8};

/* ------------- */

void f()
{
	//TODO a: find the right type for p

	/* DO NOT MODIFY */

	*p = &var1;

	if (*p == 22136)
		printf("So far so good!\n");

	/* ------------- */
}

void g()
{
	/* DO NOT MODIFY */
	int i;

	printf("%p, %p\n", &var2, v2);

	//TODO b: find the right vaue for i
	scanf("%d", &i);
	v2[i] = 0;

	if (var2 == 0)
		printf("Getting stronger\n");
	/* ------------- */
}

/* DO NOT MODIFY */
void f1()
{
	printf("Pointer ");
}

void f2()
{
	printf("hell\n");
}

void h(void *arr)
{
	void (*a)() = *((unsigned long *)arr);
	void (*b)() = *((unsigned long *)arr + 1);

	a();
	b();
}
/* ------------- */

int main(void)
{
	/* DO NOT MODIFY */
	f();
	g();
	/* ------------- */

	// TODO c: call h() with the right arguments

	return 0;
}
