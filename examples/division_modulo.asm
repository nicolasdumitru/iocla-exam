; division_modulo.asm
;
; Build:
;   nasm -f elf64 division_modulo.asm -o division_modulo.o
;   gcc division_modulo.o -o division_modulo -no-pie
;
; Run:
;   ./division_modulo

; Note: `resq` means "reserve quadwords"

section .data
    prompt_a    db "Enter dividend a: ", 0
    prompt_b    db "Enter divisor b: ", 0

    fmt_scan    db "%ld", 0

    fmt_result  db 10
                db "Input: a = %ld, b = %ld", 10
                db "Unsigned: a / b = %lu, a %% b = %lu", 10
                db "Signed:   a / b = %ld, a %% b = %ld", 10, 0

    fmt_bad     db "Invalid input.", 10, 0
    fmt_zero    db "Error: divisor b cannot be zero.", 10, 0

section .bss
    a           resq 1
    b           resq 1

    u_quot      resq 1
    u_rem       resq 1

    s_quot      resq 1
    s_rem       resq 1

section .text
    global main
    extern printf
    extern scanf

main:
    push rbp
    mov rbp, rsp

    ; ------------------------------------------------------------
    ; Read dividend a
    ; ------------------------------------------------------------

    mov rdi, prompt_a
    xor eax, eax
    call printf

    mov rdi, fmt_scan
    mov rsi, a
    xor eax, eax
    call scanf

    cmp eax, 1
    jne .bad_input

    ; ------------------------------------------------------------
    ; Read divisor b
    ; ------------------------------------------------------------

    mov rdi, prompt_b
    xor eax, eax
    call printf

    mov rdi, fmt_scan
    mov rsi, b
    xor eax, eax
    call scanf

    cmp eax, 1
    jne .bad_input

    ; ------------------------------------------------------------
    ; Safety check: division by zero
    ; ------------------------------------------------------------

    mov rcx, [b]
    cmp rcx, 0
    je .division_by_zero

    ; ------------------------------------------------------------
    ; Example 1: unsigned division
    ;
    ; Computes:
    ;   u_quot = a / b
    ;   u_rem  = a % b
    ;
    ; For unsigned division:
    ;   dividend = RDX:RAX
    ;   divisor  = RCX
    ;   quotient -> RAX
    ;   remainder -> RDX
    ; ------------------------------------------------------------

    mov rax, [a]
    xor rdx, rdx
    mov rcx, [b]
    div rcx

    mov [u_quot], rax
    mov [u_rem], rdx

    ; ------------------------------------------------------------
    ; Example 2: signed division
    ;
    ; Computes:
    ;   s_quot = a / b
    ;   s_rem  = a % b
    ;
    ; For signed division:
    ;   dividend = RDX:RAX
    ;   divisor  = RCX
    ;   quotient -> RAX
    ;   remainder -> RDX
    ;
    ; cqo sign-extends RAX into RDX:RAX.
    ; ------------------------------------------------------------

    mov rax, [a]
    cqo
    mov rcx, [b]
    idiv rcx

    mov [s_quot], rax
    mov [s_rem], rdx

    ; ------------------------------------------------------------
    ; Print both results together
    ; ------------------------------------------------------------

    mov rdi, fmt_result
    mov rsi, [a]        ; input a
    mov rdx, [b]        ; input b
    mov rcx, [u_quot]   ; unsigned quotient
    mov r8,  [u_rem]    ; unsigned remainder
    mov r9,  [s_quot]   ; signed quotient

    ; 6th printf argument after format goes on the stack:
    ; printf(format, a, b, u_quot, u_rem, s_quot, s_rem)
    push qword [s_rem]

    xor eax, eax
    call printf

    add rsp, 8          ; clean up pushed stack argument

    jmp .done

.bad_input:
    mov rdi, fmt_bad
    xor eax, eax
    call printf
    jmp .done

.division_by_zero:
    mov rdi, fmt_zero
    xor eax, eax
    call printf

.done:
    xor eax, eax
    mov rsp, rbp
    pop rbp
    ret