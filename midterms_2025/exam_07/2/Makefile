NASM = nasm
AFILES = file.asm
ASM_FLAGS = -f elf64 -g
LD=gcc
LDFLAGS = -no-pie -g
CC=gcc
CFLAGS = -g

all : file

file: file.o sum_digits.o
	$(LD) $(LDFLAGS) -o $@ $^

%.o : %.asm
	$(NASM) $(ASM_FLAGS) -o $@ $<

%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean: 
	rm -f file.o file
