%include "printf32.asm"

section .data
    test_b: dd 1, 1, 1, 3, 3, 4, 6, 7, 7, 7, 10, 11, 20, 20
    len equ 14

    fmt_sum db "Sum: %d", 10, 0
    fmt_len db "Uniq length: %d", 10, 0
    fmt_arr db "%d ", 0
    fmt_nl db 10, 0

section .text
global main
extern printf

; rdi = v, rsi = size
uniq:
    push rbp
    mov rbp, rsp
    
    ; TODO b: The `uniq` function will receive a sorted array as
    ; a parameter and remove the duplicate elements in-place.
    ; There shouldn't be any additional array used.
    test rsi, rsi
    jle .empty
    
    mov r8d, 1 ; read_idx
    mov r9d, 1 ; write_idx
    mov r10d, dword [rdi] ; previous element

.loop:
    cmp r8d, esi
    jge .done
    
    mov eax, dword [rdi + r8 * 4]
    cmp eax, r10d
    je .skip      ; if same as prev, skip
    
    mov dword [rdi + r9 * 4], eax ; write to new pos
    mov r10d, eax ; update prev
    inc r9d       ; increment write_idx
.skip:
    inc r8d       ; increment read_idx
    jmp .loop

.empty:
    mov eax, 0
    leave
    ret
.done:
    mov eax, r9d
    leave
    ret

main:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15

    ; TODO a: Create a local array and initialise it.
    ; Compute the sum of its elements and print it.
    ; local array {0, 1, 1, 1, 2, 3, 3, 5, 6, 6, 6, 6, 6}
    ; 13 * 4 = 52. align by 16 -> 64
    sub rsp, 64
    
    mov dword [rsp], 0
    mov dword [rsp+4], 1
    mov dword [rsp+8], 1
    mov dword [rsp+12], 1
    mov dword [rsp+16], 2
    mov dword [rsp+20], 3
    mov dword [rsp+24], 3
    mov dword [rsp+28], 5
    mov dword [rsp+32], 6
    mov dword [rsp+36], 6
    mov dword [rsp+40], 6
    mov dword [rsp+44], 6
    mov dword [rsp+48], 6
    
    xor rcx, rcx
    xor r13, r13 ; will hold the sum
.sum_loop:
    cmp rcx, 13
    jge .sum_done
    movsxd r12, dword [rsp + rcx * 4]
    add r13, r12
    inc rcx
    jmp .sum_loop
.sum_done:
    lea rdi, [rel fmt_sum]
    mov rsi, r13
    xor eax, eax
    call printf

    ; TODO b: Call `uniq` using `test_b`. Print the resulting
    ; length.
    lea rdi, [rel test_b]
    mov rsi, 14
    call uniq
    lea rdi, [rel fmt_len]
    mov rsi, rax ; rax has new len
    xor eax, eax
    call printf

    ; TODO c: Call `uniq` using the array allocated at a)
    ; Print it afterwards using `printf()`.
    mov rdi, rsp
    mov rsi, 13
    call uniq
    mov r14d, eax ; new length
    
    xor r15, r15
.print_loop:
    cmp r15d, r14d
    jge .print_done
    
    lea rdi, [rel fmt_arr]
    movsx rsi, dword [rsp + r15 * 4]
    xor eax, eax
    call printf
    
    inc r15
    jmp .print_loop
.print_done:
    lea rdi, [rel fmt_nl]
    xor eax, eax
    call printf

    ; Return 0
    add rsp, 64
    pop r15
    pop r14
    pop r13
    pop r12
    xor eax, eax
    leave
    ret
