CC = gcc
CFLAGS = -Wall -m32 -Wno-implicit-function-declaration
LDFLAGS = -m32 -no-pie -g

all: file

file: file.o utils.o

file.o: file.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f file.o file
	rm -f *~ 
