%include "printf32.asm"

section .data
    colors db 255, 50, 255, 0, 0, 0, 255, 255, 255, 255, 50, 255
    colors_nr dd 4

section .text
extern printf
global main

main:
    push ebp
    mov ebp, esp

    ; TODO a: Determine the number of occurances for
    ; the color pink (tuple 255, 50, 255) in the colors
    ; array
    ; NOTE: You must print the result as `Number of pinks:`
    ; followed by the determined number of occurances


    ; TODO b: Transform the second command line argument
    ; from string to int using `atoi`
    ; NOTE: You must print the result using `printf`:
    ;   * if there are less that 2 arguments, `Not enough arguments`
    ;   * otherwise, `My id is:`, followed by the integer id


    ; TODO c: Verify whether the id from the second line argument
    ; is a palindrome
    ; NOTE: You must print the result:
    ;   * if the id is palindrome, `My id is palindrome`
    ;   * otherwise, `My id is not palindrome`


    ; Return 0.
    xor eax, eax
    leave
    ret
