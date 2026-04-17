extern printf

section .data

int_fmt db "%d ", 0
int_fmt_newline db "%d ", 10, 0

N dd 120
k dd 6

arr dd 10, 20, 30, 40, 50, 60, 70, 80, 90, 100
len equ 10

section .bss
; TODO c: Reserve memory for an array `res` of `len` integer elements

section .text

global main

; TODO a: Implement `is_divisor(unsigned int n, unsigned int i)`
; which checks if `i` is a divisor of `n`
; the function returns 1 if `i` is a divisor of `n` and 0 otherwise
is_divisor:
    push ebp
    mov ebp, esp


    leave
    ret

; TODO b: Implement `count_divisors(unsigned int n)`
; which counts the number of divisors of `n` (1 and n are not counted)
; e.g:
;   count_divisors(10) = 2
;   count_divisors(13) = 0
; Hint: use `is_divisor` function
count_divisors:
    push ebp
    mov ebp, esp

    leave
    ret

main:
    push ebp
    mov ebp, esp

    ; TODO a: Call is_divisor(N, k). Use N, k from .data section.
    ; Print the result using `printf` function.
    ; You may use `int_fmt_newline` defined in .data section

    ; TODO b: Call count_divisors(N). Use N from .data section
    ; Print the result using `printf` function.
    ; You may use `int_fmt_newline` defined in .data section

    ; TODO c: Fill in array `res` with `len` elements where:
    ; element res[i] represents the number of divisors of number in arr[i]
    ; Print using `printf` function all the elements of `res` array with `len`
    ; elements on the same line separated by space
    ; You may use `int_fmt` defined in .data section

    ; Return 0.
    xor eax, eax
    leave
    ret
