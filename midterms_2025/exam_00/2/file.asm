section .data
    colors db 255, 50, 255, 0, 0, 0, 255, 255, 255, 255, 50, 255
    colors_nr dd 4
    
    fmt_pink db "Number of pinks: %d", 10, 0
    fmt_not_enough db "Not enough arguments", 10, 0
    fmt_id db "My id is: %d", 10, 0
    fmt_pal db "My id is palindrome", 10, 0
    fmt_not_pal db "My id is not palindrome", 10, 0

section .text
extern printf
extern atoi
global main

main:
    push rbp
    mov rbp, rsp
    
    ; preserve argc and argv for later tasks
    push rdi
    push rsi

    ; TODO a: Determine the number of occurances for the color pink
    mov ecx, dword [colors_nr]
    lea rbx, [rel colors]
    xor r12d, r12d ; pink count
.loop_colors:
    test ecx, ecx
    jz .done_colors
    cmp byte [rbx], 255
    jne .not_pink
    cmp byte [rbx+1], 50
    jne .not_pink
    cmp byte [rbx+2], 255
    jne .not_pink
    inc r12d
.not_pink:
    add rbx, 3
    dec ecx
    jmp .loop_colors
.done_colors:
    lea rdi, [rel fmt_pink]
    mov esi, r12d
    xor eax, eax
    call printf

    ; TODO b: Transform the second command line argument
    mov rdi, [rsp+8] ; argc
    mov rsi, [rsp]   ; argv
    
    cmp rdi, 2
    jge .enough_args
    
    lea rdi, [rel fmt_not_enough]
    xor eax, eax
    call printf
    jmp .end_prog
    
.enough_args:
    mov rdi, [rsi+8] ; argv[1]
    call atoi
    mov r12d, eax ; save parsed id
    
    lea rdi, [rel fmt_id]
    mov esi, r12d
    xor eax, eax
    call printf

    ; TODO c: Verify whether the id from the second line argument is a palindrome
    mov eax, r12d
    xor r13d, r13d
    mov ebx, 10
.rev_loop:
    test eax, eax
    jz .rev_done
    xor edx, edx
    div ebx
    mov ecx, eax
    mov esi, edx ; save remainder
    mov eax, r13d
    mul ebx
    add eax, esi ; add remainder
    mov r13d, eax
    mov eax, ecx
    jmp .rev_loop
.rev_done:
    cmp r13d, r12d
    je .is_pal
    
    lea rdi, [rel fmt_not_pal]
    xor eax, eax
    call printf
    jmp .end_prog
.is_pal:
    lea rdi, [rel fmt_pal]
    xor eax, eax
    call printf

.end_prog:
    pop rsi
    pop rdi
    xor eax, eax
    leave
    ret
