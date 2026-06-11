%include "printf64.asm"

section .data
    plaintext   db  "Hello, Worldz!", 0
    SHIFT       equ 3
 
    vowels  db "aeiou", 0
 
    fmt_enc     db  "Encoded : %s", 10, 0
    fmt_dec     db  "Decoded : %s", 10, 0
    
    fmt_vowels db "Vowels : %ld", 0
 
section .bss
    encoded     resb 64
    decoded     resb 64
 

extern printf
extern strchr
global main

section .text
main:
    push rbp
    mov rbp, rsp

    ; TODO a: Count the number of vowels in plaintext.

    xor rcx, rcx ; rcx = 0
    xor r12, r12 ; rbx = 0
.loop1:
    mov al, [plaintext + rcx]
    cmp al, 0
    je .loop1_end
    
    mov rdi, vowels
    movzx rsi, al
    call strchr
    cmp rax, 0
    je .iteration_end
    inc r12
.iteration_end:
    inc rcx
    jmp .loop1
.loop1_end:

    mov rdi, fmt_vowels
    mov rsi, r12
    xor rax, rax
    
    call printf

    ; TODO b: Shift all letters inside the plaintext string with SHIFT positions
    ; make sure to loop from z to a, e.g. y will become b (y -> z -> a -> b).



    ; TODO c: Decode the string resulted at b) back to the original form an print it.



    ; TODO d: Print the string checksum.


    ; Return 0.
    xor rax, rax
    leave
    ret

section .note.GNU-stack noalloc noexec nowrite progbits