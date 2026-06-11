; qsort_nested_example.asm
;
; Build:
;   nasm -f elf64 qsort_nested_example.asm -o qsort_nested_example.o
;   gcc -no-pie qsort_nested_example.o -o qsort_nested_example
;
; Run:
;   ./qsort_nested_example

extern qsort
extern printf

global main

section .data
    arr dq 93, -12, 44, 0, 1024, 17, -300, 8, 8, 51, -1, 700
    arr_len equ 12

    fmt db "%ld", 10, 0
    title_before db "Before sorting:", 10, 0
    title_after  db "After sorting:", 10, 0

section .text

; ------------------------------------------------------------
; int cmp_long(const void *a, const void *b)
;
; System V AMD64 ABI:
;   rdi = pointer to first element
;   rsi = pointer to second element
;
; qsort expects:
;   return < 0 if *a < *b
;   return = 0 if *a == *b
;   return > 0 if *a > *b
; ------------------------------------------------------------
cmp_long:
    push rbp
    mov rbp, rsp

    mov rax, [rdi]       ; rax = *(long *)a
    mov rdx, [rsi]       ; rdx = *(long *)b

    cmp rax, rdx
    jl .less
    jg .greater

.equal:
    xor eax, eax
    jmp .done

.less:
    mov eax, -1
    jmp .done

.greater:
    mov eax, 1

.done:
    pop rbp
    ret


; ------------------------------------------------------------
; void sort_array(long *base, unsigned long count)
;
; Arguments:
;   rdi = base pointer
;   rsi = number of elements
;
; Calls:
;   qsort(base, count, 8, cmp_long)
;
; qsort arguments under System V AMD64:
;   rdi = base
;   rsi = nmemb
;   rdx = size
;   rcx = compar
; ------------------------------------------------------------
sort_array:
    push rbp
    mov rbp, rsp

    ; At this point, after push rbp, rsp is 16-byte aligned.
    ; We do not need local variables, so no sub rsp, N is needed.

    ; rdi already contains base
    ; rsi already contains count
    mov rdx, 8           ; sizeof(long)
    mov rcx, cmp_long    ; comparator function pointer
    call qsort

    mov rsp, rbp
    pop rbp
    ret


; ------------------------------------------------------------
; void print_array(long *base, unsigned long count)
;
; Arguments:
;   rdi = base pointer
;   rsi = number of elements
;
; This function calls printf, so it preserves the callee-saved
; registers it uses: rbx, r12, r13.
; ------------------------------------------------------------
print_array:
    push rbp
    mov rbp, rsp

    push rbx
    push r12
    push r13

    ; We pushed rbp, rbx, r12, r13: 4 pushes total.
    ; On System V, function entry has rsp % 16 == 8.
    ; After 4 pushes, rsp % 16 == 8 again.
    ; That is not aligned enough before calling printf.
    ;
    ; So reserve 8 extra bytes to make rsp % 16 == 0 before calls.
    sub rsp, 8

    mov r12, rdi         ; r12 = base pointer
    mov r13, rsi         ; r13 = count
    xor rbx, rbx         ; rbx = index i = 0

.loop:
    cmp rbx, r13
    jge .done

    mov rdi, fmt
    mov rsi, [r12 + rbx * 8]
    xor eax, eax         ; required before calling variadic printf
    call printf

    inc rbx
    jmp .loop

.done:
    add rsp, 8

    pop r13
    pop r12
    pop rbx

    pop rbp
    ret


; ------------------------------------------------------------
; int main(void)
; ------------------------------------------------------------
main:
    push rbp
    mov rbp, rsp

    ; After push rbp, rsp is 16-byte aligned.
    ; Therefore calls from main are ABI-aligned.

    mov rdi, title_before
    xor eax, eax
    call printf

    mov rdi, arr
    mov rsi, arr_len
    call print_array

    mov rdi, arr
    mov rsi, arr_len
    call sort_array

    mov rdi, title_after
    xor eax, eax
    call printf

    mov rdi, arr
    mov rsi, arr_len
    call print_array

    xor eax, eax         ; return 0

    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
