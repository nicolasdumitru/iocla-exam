#include <stdio.h>
#include <stdlib.h>

char decode_me[] = {-90, -112, -118, -33, -103, -112, -112, -109};

int main() {
	unsigned char *message = malloc(9 * sizeof(*message));

	// TODO b: Store the decoded message in the `message` string.
	// The encoded message is stored in the `decode_me` array of chars.
	// The decoding consists of applying the ~ operator on every byte.
	for (int i = 0; i < 8; i++) {
		message[i] = ~decode_me[i];
	}
	message[8] = '\0';
	
	printf("%s\n", message);	
	
	// TODO a: Identifică calea bibliotecii standard C
	// Re: The binary `crackme` is dynamically linked.
	// Running `objdump -s -j .interp crackme` gives '/lib/ld-linux.so.2'
	// and running `ldd crackme` or `strings crackme` reveals `libc.so.6`.
	// The exact answer is `libc.so.6` provided by the dynamic linker/interpreter `/lib/ld-linux.so.2`.

	// TODO d: Găsește parola analizând executabilul crackme.
	// Re: Decompiling `crackme` shows it counts the occurrences of the substring `"ae"` in argv[1].
	// A counter starts at 3, decreases by 1 for every `"ae"` found, then gets passed to `sleep()` via its absolute value.
	// The checker sees if the `time()` taken is 0. So we need `sleep(0)`, which means the counter must reach 0.
	// Therefore, `"ae"` must be present exactly 3 times in the string!
	// Example valid passwords: "aeaeae", "1ae2ae3ae", "ae...ae...ae".
}

