extern printf

section .data

int_fmt db "%d ", 0
int_fmt_newline db "%d ", 10, 0
newline db 10, 0

N dd 120
k dd 6

arr dd 10, 20, 30, 40, 50, 60, 70, 80, 90, 100
len equ 10

section .bss
; TODO c: Reserve memory for an array `res` of `len` integer elements
res resd len

section .text
extern printf
global main

; rdi = n, rsi = i
is_divisor:
    push rbp
    mov rbp, rsp
    
    test rsi, rsi
    jz .not_div
    
    mov rax, rdi
    xor rdx, rdx
    div rsi
    
    test rdx, rdx
    jnz .not_div
    mov eax, 1
    jmp .done
.not_div:
    xor eax, eax
.done:
    leave
    ret

; rdi = n
count_divisors:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    
    mov rbx, rdi ; n
    mov r12, 2   ; i
    xor r13, r13 ; count
    
    cmp rbx, 2
    jl .done_b
.loop:
    cmp r12, rbx
    jge .done_b
    
    mov rdi, rbx
    mov rsi, r12
    call is_divisor
    add r13, rax ; add 1 if divisor
    
    inc r12
    jmp .loop
.done_b:
    mov rax, r13
    pop r13
    pop r12
    pop rbx
    leave
    ret

main:
    push rbp
    mov rbp, rsp
    push r12

    ; TODO a: Call is_divisor(N, k). Use N, k from .data section.
    mov edi, dword [rel N]
    mov esi, dword [rel k]
    call is_divisor
    lea rdi, [rel int_fmt_newline]
    mov esi, eax
    xor eax, eax
    call printf

    ; TODO b: Call count_divisors(N). Use N from .data section
    mov edi, dword [rel N]
    call count_divisors
    lea rdi, [rel int_fmt_newline]
    mov esi, eax
    xor eax, eax
    call printf

    ; TODO c: Fill in array `res` with `len` elements where:
    xor r12, r12
.loop_arr:
    cmp r12, 10
    jge .print_res
    
    lea rax, [rel arr]
    mov edi, dword [rax + r12 * 4]
    call count_divisors
    lea rdx, [rel res]
    mov dword [rdx + r12 * 4], eax
    
    inc r12
    jmp .loop_arr

.print_res:
    xor r12, r12 
.loop_print:
    cmp r12, 10
    jge .done_c
    
    lea rbx, [rel res]
    mov esi, dword [rbx + r12 * 4]
    lea rdi, [rel int_fmt]
    xor eax, eax
    call printf
    
    inc r12
    jmp .loop_print

.done_c:
    lea rdi, [rel newline]
    xor eax, eax
    call printf

    pop r12
    xor eax, eax
    leave
    ret
