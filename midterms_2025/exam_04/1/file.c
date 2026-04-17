#include <stdio.h>

#define TODO "TODO"

struct stud {
	char name[256];
	unsigned char grades[3];
	float mean;
};

void print_addresses(struct stud *stud)
{
	/* TODO a */

	printf("stud->name: %p\n", (void*)stud->name);
	printf("stud->grades: %p\n", (void*)stud->grades);
	printf("stud->mean: %p\n", (void*)&stud->mean);
}

void print_stud(struct stud *stud)
{
	/* TODO b */
	// We lack dot and bracket operator access. Use direct pointer casting and offsets.
	char *p = (char *)stud;
	
	// name is at offset 0
	// grades is at offset 256
	// mean is at offset 260 (due to 1 byte padding after 3-byte grades array, 256+3 = 259, padding align to 4 -> 260)
	printf("Name: %s\n", p);
	printf("Grades: %d %d %d\n", *(p + 256), *(p + 257), *(p + 258));
	printf("Mean: %f\n", *(float*)(p + 260));
}

void print_vec(struct stud *studs, int n)
{
	/* TODO c */
	// We cannot use loops. Recursion is the way.
	if (n <= 0) return;
	
	print_stud(studs);
	print_vec(studs + 1, n - 1);
}

void toggle_case(char *name)
{
	/* TODO d */
	// Recursion to traverse without loops, direct dererfence without brackets.
	if (*name == '\0') return;
	
	char c = *name;
	if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) {
		// Toggle case utilizing the XOR binary operator with the 5th bit space
		*name ^= 32;
	}
	
	toggle_case(name + 1);
}

int main(void)
{
	int i, n;
	struct stud studs[] = {
		{
			.name = "Ionescu George",
			.grades = {10, 9, 2},
			.mean = 7
		}, {
			.name = "TUDOSE Alina",
			.grades = {9, 9, 8},
			.mean = 8.66
		}, {
			.name = "Dobromir Anca-Maria",
			.grades = {10, 8, 10},
			.mean = 9.33
		},
	};

	n = sizeof(studs)/sizeof(studs[0]);

	printf("***** TASK a *****\n");
	print_addresses(&studs[0]);
	printf("***** TASK b *****\n");
	print_stud(&studs[0]);
	printf("***** TASK c *****\n");
	print_vec(studs, n);

	printf("***** TASK d *****\n");
	for (i = 0; i < n; i++) {
		printf("Before toggle: %s\n", studs[i].name);
		toggle_case(studs[i].name);
		printf("After toggle: %s\n", studs[i].name);
	}

	return 0;
}
