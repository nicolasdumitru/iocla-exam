# Registers
|Register|Common Purpose|
|--------|--------------|
|RAX|Accumulator (used for math and return values)
|RBX|Base register
|RCX|Counter (loops)
|RDX|Data (math/I/O)
|RSI|Source Index (strings/arrays)
|RDI|Destination Index (strings/arrays)
|RSP|Stack Pointer (points to the top of the stack)
|RBP|Base Pointer (points to the start of a function frame)
|R8 - R15|General-purpose extra registers

Sub-register Sizes:
If you see EAX, that’s just the lower 32 bits of RAX. AX is 16 bits, and AL is 8 bits.

# Program Structure
A NASM file is divided into three main "sections":

section .data: For initialized constants (e.g., strings, fixed numbers).

section .bss: For uninitialized variables (reserving space).

section .text: Where the actual code lives. You must declare global _start so the linker knows where to begin.

# Basic Instructions
In NASM, the syntax is generally: instruction destination, source

Data Movement
mov rax, 10 : Put the number 10 into RAX.

mov rbx, rax : Copy the value in RAX into RBX.

lea rdi, [var] : Load Effective Address. Puts the memory address of var into RDI (not the value at that address).

Arithmetic
add rax, 5 : RAX = RAX + 5

sub rbx, rcx : RBX = RBX - RCX

inc rax / dec rax : Increment or decrement by 1.

imul rax, rbx : Signed multiplication.

Control Flow (If/Then/Loops)
cmp rax, rbx: Compares the two (subtracts them internally and sets "flags").

je / jne: Jump if Equal / Not Equal.

jg / jl: Jump if Greater / Less.

jmp label: Unconditionally go to a specific part of the code.

# Memory Addressing
When you see square brackets [ ], it means "go to this address in memory."

mov rax, [my_var] : Load the value stored at my_var into RAX.

mov [rbx], rax : Move the value in RAX into the memory address pointed to by RBX.

# NASM Size Directives
|Keyword|Size|Example|
|-------|----|-------|
|byte|8 bits|"mov byte [rbx]| 10"
|word|16 bits|"mov word [rbx]| 10"
|dword|32 bits|"mov dword [rbx]| 10"
|qword|64 bits|"mov qword [rbx]| 10"

# Instructions
## `mov`
### Syntax
```asm
mov destination, source
```
### Memory access
- accessing an address
```asm
mov destination, my_variable
```
- accessing contents ("dereferencing")
```asm
mov destination, [my_variable]
```
### Valid operand combinations
|Destination|Source|Example|
|-----------|------|-------|
|Register|Register|"mov rbp| rsp"
|Register|Immediate (Constant)|"mov rax| 100"
|Register|Memory|"mov rdx| [rbp - 8]"
|Memory|Register|"mov [rdi]| rax"
|Memory|Immediate|"mov dword [rbx]| 5"

> The Golden Rule: No Memory-to-Memory

|Keyword|Size|bits|
|-------|----|----|
| byte |1 byte |8 bits |
| word |2 bytes|16 bits|
| dword|4 bytes|32 bits|
| qword|8 bytes|64 bits|

```asm
mov byte [rax], 1    ; Store 1 as a single byte
mov qword [rax], 1   ; Store 1 as a 64-bit value
```


## TODO
movabs
movsx
movabs




# System Calls (The Linux Way)
To actually do something (like print text or exit), you talk to the Kernel using a syscall.

Put the Syscall Number in rax.

Put arguments in rdi, rsi, rdx (in that order).

Call syscall.

Common Syscalls:

Exit: rax = 60, rdi = error code (0 for success)

Write: rax = 1, rdi = file descriptor (1 for stdout), rsi = pointer to string, rdx = length