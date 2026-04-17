section .text
    global _start

_start:
    ; --- 1. Constant Shift ---
    mov rax, 0x1          ; RAX = 1
    shl rax, 4            ; RAX = 1 << 4 (Result: 0x10 or 16)

    ; --- 2. Variable Shift using CL ---
    mov rbx, 0x1          ; RBX = 1
    mov rcx, 5            ; We want to shift by 5. Note: This sets the whole RCX.
    shl rbx, cl           ; RBX = 1 << 5 (Result: 0x20 or 32)

    ; --- 3. The Masking Effect ---
    mov rdx, 0x1
    mov cl, 65            ; 65 is 1000001 in binary
    shl rdx, cl           ; Shift is masked to 6 bits (65 % 64 = 1)
                          ; RDX becomes 0x2, NOT zero!

    ; --- 4. BMI2 Shift (Optional/Modern) ---
    ; Note: This will crash if your CPU is older than ~2013 (pre-Haswell)
    mov r8, 0x1
    mov r9, 3
    shlx r10, r8, r9      ; R10 = R8 << R9 (Result: 0x8)
    ; the 3 registers used by shlx CAN be the same. It is possible to do
    shlx r10, r10, r10

    ; --- Exit Program ---
    mov rax, 60           ; sys_exit syscall number
    xor rdi, rdi          ; return 0
    syscall