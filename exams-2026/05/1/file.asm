%include "printf64.asm"

section .data
    plaintext   db  "Hello, Worldz!", 0
    SHIFT       equ 3
 
    fmt_enc     db  "Encoded : %s", 10, 0
    fmt_dec     db  "Decoded : %s", 10, 0
 
section .bss
    encoded     resb 64
    decoded     resb 64
 

section .text
extern printf
global main

main:
    push rbp
    mov rbp, rsp

    ; TODO a: Count the number of vowels in plaintext.


    ; TODO b: Shift all letters inside the plaintext string with SHIFT positions
    ; make sure to loop from z to a, e.g. y will become b (y -> z -> a -> b).



    ; TODO c: Decode the string resulted at b) back to the original form an print it.



    ; TODO d: Print the string checksum.


    ; Return 0.
    xor rax, rax
    leave
    ret
