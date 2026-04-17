#include <stdio.h>
#include <stdlib.h>

char *get_magic();

int main() {
	char *message = get_magic();
	
	// TODO b: Find out why this is not printing the entire message, and fix it.
	printf("%s\n", message);
	
	return 0;
}

