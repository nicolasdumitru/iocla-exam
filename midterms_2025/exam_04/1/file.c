#include <stdio.h>

#define TODO "TODO"

struct stud {
	char name[256];
	unsigned char grades[3];
	float mean;
};

void print_addresses(struct stud *stud)
{
	/* TODO */

	printf("stud->name: TODO\n", TODO);
	printf("stud->grades: TODO\n", TODO);
	printf("stud->mean: TODO\n", TODO);
}

void print_stud(struct stud *stud)
{
	/* TODO */

	printf("Name: %s\n", TODO);
	printf("Grades: %d %d %d\n", 0 /*TODO*/, 0 /*TODO*/, 0/*TODO*/);
	printf("Mean: %f\n", 0/*TODO*/);
}

void print_vec(struct stud *studs, int n)
{
	/* TODO */
	return;
}

void toggle_case(char *name)
{
	/* TODO */

	return;

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
