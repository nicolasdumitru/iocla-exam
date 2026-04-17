section .data
    ; Exercise a: Overflow Detection
    coordonates dd 0x70000000, 0x70000000   ; X and Y coordinates
    speed dd 0x20000000                     ; Ship speed
    msg_overflow db "ALERT! Overflow detected in trajectory calculation!", 10, 0
    msg_succes db "Trajectory calculated successfully: X=%d, Y=%d", 10, 0
    
    ; Exercise b: Matrix addressing correction
    matrix dd 10, 20, 30, 40, 50, 60, 70, 80, 90
    format_matrix db "Element at position (%d,%d) is: %d", 10, 0
    
    ; Exercise c: Processing binary messages as ASCII strings
    binary_message dd 0x52415453, 0x50414D5F, 0x00000000
    size dd 3
    decoded_message times 16 db 0
    format_message db "Decoded message: %s", 10, 0
    
    ; Separators for display
    separator db "----------------------------------------", 10, 0
    header_ex1 db "Exercise a: Overflow Detection", 10, 0
    header_ex2 db "Exercise b: Matrix Addressing Correction", 10, 0
    header_ex3 db "Exercise c: Binary Message Processing", 10, 0

section .text
extern printf
global main

main:
    push rbp
    mov rbp, rsp
    
    ; Exercise a: Overflow Detection
    lea rdi, [rel header_ex1]
    xor eax, eax
    call printf
    
    ; TODO a: Add speed to each coordinate, but check for overflow
    ; Jump to the overflow_detected label if it is the case
    mov eax, dword [rel coordonates]     ; X coordinate
    add eax, dword [rel speed]           ; Add speed
    jo overflow_detected
    mov ebx, eax                         ; Save new X

    mov ecx, dword [rel coordonates + 4] ; Y coordinate
    add ecx, dword [rel speed]           ; Add speed
    jo overflow_detected
    
    ; Trajectory successful
    lea rdi, [rel msg_succes]
    mov esi, ebx
    mov edx, ecx
    xor eax, eax
    call printf
    jmp final_ex1

overflow_detected:
    lea rdi, [rel msg_overflow]
    xor eax, eax
    call printf

final_ex1:
    lea rdi, [rel separator]
    xor eax, eax
    call printf
    
    ; Exercise b: Matrix Addressing Correction
    lea rdi, [rel header_ex2]
    xor eax, eax
    call printf
    
    ; Coordinates of the searched element (row 2, column 1)
    mov edi, 1    ; Column
    mov esi, 2    ; Row
    
    ; TODO b: Correct the addressing to get the correct element from the matrix
    ; matrix is 3x3 of dwords, row-major: pos = (row * 3 + col) * 4
    mov eax, esi
    imul eax, 3
    add eax, edi
    lea rbx, [rel matrix]
    mov ebx, dword [rbx + rax * 4]
    
    ; Display the result
    push rbx          ; Element value (preserve to balance or pass)
    ; In 64-bit, args go in rdi, rsi, rdx, rcx, r8, r9
    ; The format string is "Element at position (%d,%d) is: %d"
    ; So rsi = row, rdx = col, rcx = val
    mov ecx, ebx      ; rcx = Element value
    mov edx, edi      ; rdx = Column
    ; rsi is already Row (it was 2)
    lea rdi, [rel format_matrix]
    xor eax, eax
    call printf
    pop rbx
    
    lea rdi, [rel separator]
    xor eax, eax
    call printf
    
    ; Exercise c: Processing Binary Messages as ASCII Strings
    lea rdi, [rel header_ex3]
    xor eax, eax
    call printf
    
    ; TODO c: Traverse the int array and extract each byte
    ; transforming it into an ASCII character in decoded_message
    lea rsi, [rel binary_message]
    lea rdi, [rel decoded_message]
    mov ecx, dword [rel size]
    shl ecx, 2      ; multiply by 4 to get number of bytes
    
.decode_loop:
    test ecx, ecx
    jz .decode_done
    mov al, byte [rsi]
    mov byte [rdi], al
    inc rsi
    inc rdi
    dec ecx
    jmp .decode_loop
.decode_done:
    ; Display the decoded message
    lea rdi, [rel format_message]
    lea rsi, [rel decoded_message]
    xor eax, eax
    call printf
    
    lea rdi, [rel separator]
    xor eax, eax
    call printf
    
    ; Return 0
    xor eax, eax
    leave
    ret