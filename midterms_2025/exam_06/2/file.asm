%include "printf32.asm"

section .data
    test_b: dd 1, 1, 1, 3, 3, 4, 6, 7, 7, 7, 10, 11, 20, 20
    len equ 14

section .text
global main
extern printf

uniq:
    push ebp
    mov ebp, esp

    ; TODO b: The `uniq` function will receive a sorted array as
    ; a parameter and remove the duplicate elements in-place.
    ; There shouldn't be any additional array used.

    leave
    ret

main:
    push ebp
    mov ebp, esp


    ; TODO a: Create a local array and initialise it.
    ; Compute the sum of its elements and print it.

    ; TODO b: Call `uniq` using `test_b`. Print the resulting
    ; length.

    ; TODO c: Call `uniq` using the array allocated at a)
    ; Print it afterwards using `printf()`.


    ; Return 0.
    xor eax, eax
    leave
    ret
