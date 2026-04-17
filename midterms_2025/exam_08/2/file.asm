%include "printf32.asm"

section .data
    w db "y12a"
    len equ $-w
    
    str_ana db "Ana", 0
    str_are db "are", 0
    str_alune db "alune", 0
    str_buun3 db "Buun3", 0
    
    fmt_checks db "Sentence checks", 10, 0
    fmt_not_checks db "Sentence doesn't check", 10, 0
    fmt_not_enough db "Not enough arguments", 10, 0
    fmt_check_is db "My check is: %d", 10, 0

section .text
extern printf
extern strlen
global main

; rdi = s, rsi = len
check_controlsum:
    push rbp
    mov rbp, rsp
    
    test rsi, rsi
    jle .ok
    
    xor rcx, rcx
    mov r8, rsi
    dec r8
    
    ; len/2 loop restriction
    mov r9, rsi
    shr r9, 1
.loop:
    cmp rcx, r9
    jge .ok
    
    mov al, byte [rdi + rcx]
    mov dl, byte [rdi + r8]
    add al, dl
    
    jno .fail
    
    inc rcx
    dec r8
    jmp .loop
    
.ok:
    mov eax, 1
    leave
    ret
.fail:
    mov eax, 0
    leave
    ret

main:
    push rbp
    mov rbp, rsp
    push rbx
    
    push rdi ; argc
    push rsi ; argv

    ; TODO a: Call `check_controlsum` with the w string and len
    lea rdi, [rel w]
    mov rsi, len
    call check_controlsum
    lea rdi, [rel fmt_check_is]
    mov rsi, rax
    xor eax, eax
    call printf

    ; TODO b: Use `check_controlsum` to decide whether all locally storred words...
    lea rdi, [rel str_ana]
    mov rsi, 3
    call check_controlsum
    test eax, eax
    jz .sentence_fail
    
    lea rdi, [rel str_are]
    mov rsi, 3
    call check_controlsum
    test eax, eax
    jz .sentence_fail
    
    lea rdi, [rel str_alune]
    mov rsi, 5
    call check_controlsum
    test eax, eax
    jz .sentence_fail
    
    lea rdi, [rel str_buun3]
    mov rsi, 5
    call check_controlsum
    test eax, eax
    jz .sentence_fail
    
    lea rdi, [rel fmt_checks]
    xor eax, eax
    call printf
    jmp .task_c
    
.sentence_fail:
    lea rdi, [rel fmt_not_checks]
    xor eax, eax
    call printf

.task_c:
    pop rsi ; argv
    pop rdi ; argc
    
    cmp rdi, 2
    jge .enough
    
    lea rdi, [rel fmt_not_enough]
    xor eax, eax
    call printf
    jmp .end_main
    
.enough:
    mov rbx, [rsi+8] ; argv[1]
    mov rdi, rbx
    call strlen
    mov rsi, rax
    mov rdi, rbx
    call check_controlsum
    
    lea rdi, [rel fmt_check_is]
    mov rsi, rax
    xor eax, eax
    call printf

.end_main:
    pop rbx
    xor eax, eax
    leave
    ret
