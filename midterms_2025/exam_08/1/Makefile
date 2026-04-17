CC = gcc
CFLAGS = -Wall -m32 -Wno-implicit-function-declaration
LDFLAGS = -m32 -no-pie
BINARIES = file

all: $(BINARIES)

file: file.o my-hierarchy/helpers.o

file.o: file.c 
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f file.o $(BINARIES)
	rm -f *~ 
