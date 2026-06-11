; nasm -f elf64 printf_example.asm -o printf_example.o
; gcc -no-pie printf_example.o -o printf_example

extern printf
global main

section .data
fmt db "value = %ld", 10, 0

section .text
main:
    push rbp
    mov rbp, rsp

    mov rdi, fmt     ; 1st argument: format string
    mov rsi, 123     ; 2nd argument: value
    xor eax, eax     ; required for variadic functions: number of vector args
    call printf

    xor eax, eax     ; return 0

    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
