%include "printf32.asm"

section .data
    w db "y12a"
    len equ $-w

section .text
extern printf
global main

; TODO a: Implement `int check_controlsum(char *s, int len)` which checks
; whether a string has all its mirrored characters sum up to result
; in overflow
; The overflow should occur on the signed char type

check_controlsum:
    push ebp
    mov ebp, esp

    leave
    ret

main:
    push ebp
    mov ebp, esp

    ; TODO a: Call `check_controlsum` with the w string and len, storred in
    ; .data
    ; NOTE: You must print the result



    ; TODO b: Use `check_controlsum` to decide whether all locally
    ; storred words `Ana`, `are`, `alune`, `Buun3` have the
    ; overflow property
    ; NOTE: Print `Sentence checks` if all the words have the
    ; overflow property, otherwise `Sentence doesn't check`



    ; TODO c: Use `check_controlsum` to decide whether the second
    ; command line argument has the overflow property
    ; NOTE: If there are less than 2 arguments, print `Not enough
    ; arguments`, otherwise `My check is:` followed by the function
    ; return value



    ; Return 0.
    xor eax, eax
    leave
    ret
