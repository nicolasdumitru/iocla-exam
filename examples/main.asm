section .data
    msg db "Hello, Assembly!", 10  ; 'db' means Define Bytes. 10 is a newline.
    len equ $ - msg                ; 'equ' calculates the length of the string.

section .text
    global _start

_start:
    ; --- WRITE syscall ---
    mov rax, 1      ; syscall number for sys_write
    mov rdi, 1      ; file descriptor 1 (stdout)
    mov rsi, msg    ; address of the string
    mov rdx, len    ; length of the string
    syscall         ; trigger the kernel

    ; --- EXIT syscall ---
    mov rax, 60     ; syscall number for sys_exit
    mov rdi, 0      ; return code 0
    syscall