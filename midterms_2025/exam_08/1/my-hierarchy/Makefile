CC = gcc
CFLAGS = -Wall -m32 -Wno-implicit-function-declaration
LDFLAGS = -m32 -no-pie
BINARIES = ops

all: $(BINARIES)

ops.o: ops.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f ops.o $(BINARIES)
	rm -f *~ 
