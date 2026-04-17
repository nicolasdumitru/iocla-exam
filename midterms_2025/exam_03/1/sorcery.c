#include <stdio.h>
#include <stdlib.h>

char *get_magic();

int main() {
	char *message = get_magic();
	
	// TODO b: Find out why this is not printing the entire message, and fix it.
	// The problem is that the message contains null-terminating bytes '\0' internally
	// which causes standard string printing functions like `printf("%s")` to halt early.
	// The standard C way to blindly print 66 raw bytes of a memory buffer is `fwrite`.
	fwrite(message, 1, 66, stdout);
	printf("\n"); // add a final newline just in case
	
	return 0;
}

