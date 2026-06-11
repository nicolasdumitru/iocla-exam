---
title: "IOCLA - x64 Stack Explanation"
source: "https://chatgpt.com/g/g-p-6a29e0280b3081919a5ad52340278e73-iocla/c/6a29e02f-0500-83eb-b758-c809e8a86b62"
author:
published:
created: 2026-06-11
description: "ChatGPT is your AI chatbot for everyday use. Chat with the most advanced AI to explore ideas, solve problems, and learn faster."
tags:
  - "clippings"
---
Explain to me how the stack works from an x64 assembly point of view. Use nasm syntax if you want to provide code snippets/examples

2/2

In x64 assembly, the **stack** is a memory region used mainly for:

1. storing return addresses during function calls,
2. saving registers,
3. passing some function arguments,
4. storing local variables,
5. temporary scratch storage.

The key register is:

```markdown
rsp     ; stack pointer
```

`rsp` points to the current top of the stack.

On x86-64, the stack grows **downward**, from higher addresses toward lower addresses.

So when you push something onto the stack, `rsp` decreases.

---

## Basic stack model

Imagine memory like this:

```markdown
higher addresses
+----------------+
|                |
| old data       |
|                |
+----------------+
| top of stack   |  <- rsp
+----------------+
lower addresses
```

When you do:

```markdown
push rax
```

the CPU does roughly:

```markdown
sub rsp, 8
mov [rsp], rax
```

Because x64 registers are 8 bytes wide.

After the push:

```markdown
higher addresses
+----------------+
| old data       |
+----------------+
| saved rax      |  <- rsp
+----------------+
lower addresses
```

When you do:

```markdown
pop rax
```

the CPU does roughly:

```markdown
mov rax, [rsp]
add rsp, 8
```

So `pop` reads from the current stack top, then moves `rsp` upward.

---

## push and pop

Example:

```markdown
section .text
global _start

_start:
    mov rax, 123
    push rax

    mov rax, 0
    pop rax        ; rax = 123

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall
```

The stack is **last in, first out**.

```markdown
push 10
push 20
push 30

pop rax     ; rax = 30
pop rbx     ; rbx = 20
pop rcx     ; rcx = 10
```

---

## Stack slots

You can access stack memory directly with `[rsp + offset]`.

Example:

```markdown
push 111
push 222
push 333
```

The stack now looks like:

```markdown
[rsp]      = 333
[rsp + 8]  = 222
[rsp + 16] = 111
```

So:

```markdown
mov rax, [rsp]       ; rax = 333
mov rbx, [rsp + 8]   ; rbx = 222
mov rcx, [rsp + 16]  ; rcx = 111
```

Remember: the most recently pushed value is at `[rsp]`.

---

## Function calls and return addresses

The stack is heavily involved in function calls.

When you execute:

```markdown
call my_function
```

the CPU does two things:

```markdown
push address_after_call
jmp my_function
```

So `call` pushes the return address onto the stack, then jumps to the function.

When the function finishes, it uses:

```markdown
ret
```

`ret` does roughly:

```markdown
pop rip
```

You cannot directly write `pop rip`, but conceptually `ret` pops the return address into the instruction pointer.

Example:

```markdown
section .text
global _start

_start:
    call my_function

    ; execution resumes here after ret
    mov rax, 60
    xor rdi, rdi
    syscall

my_function:
    mov rax, 42
    ret
```

When `_start` calls `my_function`, the stack contains the address of the instruction after the `call`.

Inside `my_function`:

```markdown
[rsp] = return address
```

Then `ret` jumps back there.

---

## Stack frame

A **stack frame** is the area of the stack used by one function call.

A typical stack frame contains:

```markdown
function arguments, depending on ABI
return address
saved base pointer
saved registers
local variables
temporary storage
```

Historically, x86 code often uses `rbp` as a stable frame pointer.

Typical function prologue:

```markdown
push rbp
mov rbp, rsp
sub rsp, 32
```

Typical function epilogue:

```markdown
mov rsp, rbp
pop rbp
ret
```

Or equivalently:

```markdown
leave
ret
```

`leave` means roughly:

```markdown
mov rsp, rbp
pop rbp
```

---

## Example stack frame

```markdown
my_function:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov qword [rbp - 8], 123
    mov qword [rbp - 16], 456

    mov rax, [rbp - 8]
    add rax, [rbp - 16]

    mov rsp, rbp
    pop rbp
    ret
```

After:

```markdown
push rbp
mov rbp, rsp
sub rsp, 16
```

the layout is:

```markdown
higher addresses

[rbp + 8]   return address
[rbp]       old rbp
[rbp - 8]   local variable 1
[rbp - 16]  local variable 2

lower addresses
```

So:

```markdown
[rbp - 8]
```

refers to a local variable.

And:

```markdown
[rbp + 8]
```

refers to the return address.

This is why `rbp` is useful: even if `rsp` changes during the function, `rbp` remains stable.

---

## rsp versus rbp

`rsp` always points to the current top of the stack.

`rbp` is often used as a stable reference point for the current function’s stack frame.

Example:

```markdown
push rbp
mov rbp, rsp
sub rsp, 32
```

Now:

```markdown
rsp
```

points to the bottom of the reserved local-variable area.

```markdown
rbp
```

points to the saved old base pointer.

If you later do more pushes:

```markdown
push rax
push rbx
```

`rsp` changes, but `rbp` does not.

So local variables can still be addressed reliably:

```markdown
mov rax, [rbp - 8]
```

Compilers often omit `rbp` in optimized builds and use `rsp` directly, but when learning assembly, using `rbp` makes the stack easier to understand.

---

## Local variables on the stack

Suppose you want space for three 64-bit local variables.

Each is 8 bytes, so you need 24 bytes.

```markdown
my_function:
    push rbp
    mov rbp, rsp
    sub rsp, 24

    mov qword [rbp - 8], 10
    mov qword [rbp - 16], 20
    mov qword [rbp - 24], 30

    mov rax, [rbp - 8]
    add rax, [rbp - 16]
    add rax, [rbp - 24]

    leave
    ret
```

Stack layout:

```markdown
[rbp + 8]   return address
[rbp]       old rbp
[rbp - 8]   local 1
[rbp - 16]  local 2
[rbp - 24]  local 3
```

---

## Calling conventions

The exact use of the stack depends on the operating system ABI.

The two major x64 calling conventions are:

1. **System V AMD64 ABI**: Linux, macOS, BSD.
2. **Microsoft x64 calling convention**: Windows.

They differ in how arguments are passed, which registers must be preserved, stack alignment rules, and special stack areas.

---

## Linux/macOS/BSD: System V AMD64 ABI

On Linux x86-64, the first six integer or pointer arguments are passed in registers:

```markdown
1st arg: rdi
2nd arg: rsi
3rd arg: rdx
4th arg: rcx
5th arg: r8
6th arg: r9
```

Further arguments go on the stack.

Return value:

```markdown
rax
```

Example C function:

```markdown
long add(long a, long b) {
    return a + b;
}
```

Equivalent NASM-style assembly:

```markdown
global add

section .text
add:
    mov rax, rdi
    add rax, rsi
    ret
```

Here:

```markdown
rdi = a
rsi = b
rax = return value
```

No stack frame is needed because there are no local stack variables.

---

## System V stack argument example

A function with more than six integer arguments:

```markdown
long f(long a, long b, long c, long d, long e, long f, long g) {
    return g;
}
```

Arguments:

```markdown
a -> rdi
b -> rsi
c -> rdx
d -> rcx
e -> r8
f -> r9
g -> stack
```

At function entry, the stack looks like:

```markdown
[rsp]      return address
[rsp + 8]  7th argument
[rsp + 16] 8th argument
...
```

With a frame pointer:

```markdown
global get_seventh

section .text
get_seventh:
    push rbp
    mov rbp, rsp

    mov rax, [rbp + 16] ; 7th argument

    pop rbp
    ret
```

Why `[rbp + 16]`?

After the prologue:

```markdown
[rbp]      old rbp
[rbp + 8]  return address
[rbp + 16] 7th argument
```

Without `rbp`, at function entry the 7th argument would be at `[rsp + 8]`.

---

## System V register preservation

Some registers are **caller-saved**. A function may freely overwrite them.

Common caller-saved registers:

```markdown
rax, rcx, rdx, rsi, rdi, r8, r9, r10, r11
```

Some registers are **callee-saved**. If a function uses them, it must restore them before returning.

Callee-saved registers:

```markdown
rbx, rbp, r12, r13, r14, r15
```

Example:

```markdown
my_function:
    push rbp
    mov rbp, rsp

    push rbx        ; save callee-saved register

    mov rbx, 123
    ; use rbx safely

    pop rbx         ; restore original rbx

    pop rbp
    ret
```

If you modify `rbx` without restoring it, you violate the calling convention.

---

## Windows x64 calling convention

On Windows x64, the first four integer or pointer arguments are passed in:

```markdown
1st arg: rcx
2nd arg: rdx
3rd arg: r8
4th arg: r9
```

Return value:

```markdown
rax
```

Example:

```markdown
; Windows x64
global add

section .text
add:
    mov rax, rcx
    add rax, rdx
    ret
```

The first argument is in `rcx`, not `rdi`.

---

## Windows shadow space

Windows x64 requires the caller to reserve 32 bytes of **shadow space** before calling a function.

This is also called **home space**.

Example:

```markdown
sub rsp, 40
call some_function
add rsp, 40
```

Why 40?

The required shadow space is 32 bytes.

The extra 8 bytes is often used to maintain 16-byte stack alignment before the call.

Inside a Windows x64 function, at entry:

```markdown
[rsp]      return address
[rsp + 8]  shadow space for rcx
[rsp + 16] shadow space for rdx
[rsp + 24] shadow space for r8
[rsp + 32] shadow space for r9
[rsp + 40] 5th argument
```

So the fifth integer argument is on the stack at `[rsp + 40]` at function entry.

With a typical frame pointer:

```markdown
push rbp
mov rbp, rsp
```

the layout changes:

```markdown
[rbp]      old rbp
[rbp + 8]  return address
[rbp + 16] shadow space slot 1
[rbp + 24] shadow space slot 2
[rbp + 32] shadow space slot 3
[rbp + 40] shadow space slot 4
[rbp + 48] 5th argument
```

---

## Stack alignment

Many x64 ABIs require the stack to be aligned to a 16-byte boundary at function call boundaries.

This matters for instructions like SSE/AVX loads and for calling library functions.

On System V AMD64:

Before a `call`, the caller must align `rsp` to 16 bytes.

But `call` pushes an 8-byte return address, so inside the called function, on entry:

```markdown
rsp % 16 == 8
```

Then a typical function does:

```markdown
push rbp
mov rbp, rsp
```

`push rbp` subtracts 8, so now:

```markdown
rsp % 16 == 0
```

If you reserve local stack space, you usually reserve a multiple of 16 bytes.

Example:

```markdown
my_function:
    push rbp
    mov rbp, rsp
    sub rsp, 32      ; keep alignment

    ; call another function safely
    call other_function

    leave
    ret
```

But this would misalign the stack:

```markdown
my_function:
    push rbp
    mov rbp, rsp
    sub rsp, 8       ; bad if you call another function

    call other_function

    leave
    ret
```

After `sub rsp, 8`, the stack is no longer 16-byte aligned before the call.

---

## Example: calling printf on Linux

Using NASM and the System V ABI:

```markdown
extern printf
global main

section .data
fmt db "value = %ld", 10, 0

section .text
main:
    push rbp
    mov rbp, rsp

    mov rdi, fmt     ; 1st argument: format string
    mov rsi, 123     ; 2nd argument: value
    xor eax, eax     ; required for variadic functions: number of vector args
    call printf

    xor eax, eax     ; return 0

    pop rbp
    ret
```

Important details:

```markdown
mov rdi, fmt
```

puts the first argument in `rdi`.

```markdown
mov rsi, 123
```

puts the second argument in `rsi`.

```markdown
xor eax, eax
```

is needed for System V variadic functions like `printf`. It tells the callee how many vector registers are used for floating-point variadic arguments.

The stack is aligned because:

1. `main` is entered with `rsp % 16 == 8`,
2. `push rbp` makes `rsp % 16 == 0`,
3. `call printf` is made with correct alignment.

---

## Example: local variables and a function call

```markdown
extern printf
global main

section .data
fmt db "sum = %ld", 10, 0

section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov qword [rbp - 8], 10
    mov qword [rbp - 16], 20

    mov rax, [rbp - 8]
    add rax, [rbp - 16]

    mov rdi, fmt
    mov rsi, rax
    xor eax, eax
    call printf

    xor eax, eax
    leave
    ret
```

Stack layout inside `main`:

```markdown
[rbp + 8]   return address
[rbp]       old rbp
[rbp - 8]   local variable 1 = 10
[rbp - 16]  local variable 2 = 20
```

---

## Leaf functions

A **leaf function** is a function that does not call any other function.

Example:

```markdown
global square

section .text
square:
    mov rax, rdi
    imul rax, rdi
    ret
```

This function does not need a stack frame.

It receives its argument in `rdi`, returns the square in `rax`, and returns.

Leaf functions often avoid touching the stack entirely.

---

## Red zone on System V

On System V AMD64, there is a 128-byte area below `rsp` called the **red zone**.

A leaf function may use this area without adjusting `rsp`.

Example:

```markdown
; Linux/macOS/BSD System V ABI only
global leaf_example

section .text
leaf_example:
    mov qword [rsp - 8], 123
    mov rax, [rsp - 8]
    ret
```

This is allowed on System V for leaf functions.

Do **not** rely on this on Windows x64.

Also, kernel code and interrupt handlers generally should not use the red zone.

For beginner assembly, it is often simpler to avoid the red zone and explicitly reserve stack space with `sub rsp, ...`.

---

## Saving registers on the stack

Suppose you want to use `rbx`.

On System V and Windows x64, `rbx` is callee-saved. You must preserve it.

```markdown
my_function:
    push rbp
    mov rbp, rsp

    push rbx

    mov rbx, rdi
    add rbx, 5
    mov rax, rbx

    pop rbx

    pop rbp
    ret
```

The stack during the function:

```markdown
[rbp + 8]   return address
[rbp]       old rbp
[rbp - 8]   saved rbx
```

You could also save it with an explicit local slot:

```markdown
sub rsp, 16
mov [rbp - 8], rbx

; use rbx

mov rbx, [rbp - 8]
```

But `push rbx` / `pop rbx` is common.

---

## Stack cleanup

In modern x64 calling conventions, the **caller** usually cleans up stack arguments after a call.

Example, System V with more than six arguments:

```markdown
; call f(1, 2, 3, 4, 5, 6, 7, 8)

mov rdi, 1
mov rsi, 2
mov rdx, 3
mov rcx, 4
mov r8,  5
mov r9,  6

push 8
push 7
call f
add rsp, 16
```

The stack arguments are pushed right-to-left, so the 7th argument is closest to the return address.

At `f` entry:

```markdown
[rsp]      return address
[rsp + 8]  7th argument = 7
[rsp + 16] 8th argument = 8
```

After `f` returns, the caller does:

```markdown
add rsp, 16
```

to remove the two stack arguments.

---

## Stack corruption

The stack is fragile. If you mismatch pushes and pops, return addresses can be damaged.

Bad example:

```markdown
my_function:
    push rbx
    ret
```

This is wrong.

Why?

`ret` expects the return address at `[rsp]`.

But after `push rbx`, `[rsp]` contains the saved `rbx`, not the return address.

So `ret` tries to jump to the old value of `rbx`.

Correct:

```markdown
my_function:
    push rbx

    ; use rbx

    pop rbx
    ret
```

Another bad example:

```markdown
my_function:
    sub rsp, 32
    ret
```

Again, `ret` now reads from the wrong location.

Correct:

```markdown
my_function:
    sub rsp, 32

    ; use local stack space

    add rsp, 32
    ret
```

Or:

```markdown
my_function:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    ; use local stack space

    leave
    ret
```

---

## Overwriting the return address

Since the return address is stored on the stack, writing beyond local variables can overwrite it.

Example:

```markdown
my_function:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov qword [rbp - 8], 111
    mov qword [rbp - 16], 222

    ; dangerous: this writes where the old rbp is stored
    mov qword [rbp], 333

    ; very dangerous: this overwrites the return address
    mov qword [rbp + 8], 444

    leave
    ret
```

Stack layout:

```markdown
[rbp + 8]   return address
[rbp]       old rbp
[rbp - 8]   local 1
[rbp - 16]  local 2
```

Writing to `[rbp + 8]` changes where `ret` will jump.

This is the basic mechanism behind many classic stack-based exploits, though modern systems use protections such as stack canaries, ASLR, NX, and control-flow protections.

---

## Recursive calls

Each function call gets its own stack frame.

Example recursive factorial:

```markdown
global factorial

section .text
factorial:
    push rbp
    mov rbp, rsp

    cmp rdi, 1
    jle .base_case

    push rdi            ; save n

    sub rdi, 1
    call factorial      ; factorial(n - 1)

    pop rdi             ; restore n
    imul rax, rdi
    jmp .done

.base_case:
    mov rax, 1

.done:
    pop rbp
    ret
```

Calling:

```markdown
factorial(4)
```

creates nested frames:

```markdown
factorial(4)
  factorial(3)
    factorial(2)
      factorial(1)
```

Each call has its own return address, saved `rbp`, and saved local data.

This is why recursion consumes stack space.

---

## Stack and syscalls on Linux

Linux system calls use a different convention than normal C function calls.

For `syscall` on x86-64 Linux:

```markdown
rax = syscall number
rdi = arg1
rsi = arg2
rdx = arg3
r10 = arg4
r8  = arg5
r9  = arg6
```

The stack is not used for normal syscall arguments.

Example:

```markdown
section .data
msg db "hello", 10
len equ $ - msg

section .text
global _start

_start:
    ; write(1, msg, len)
    mov rax, 1      ; SYS_write
    mov rdi, 1      ; stdout
    mov rsi, msg
    mov rdx, len
    syscall

    ; exit(0)
    mov rax, 60     ; SYS_exit
    xor rdi, rdi
    syscall
```

Here, the stack is not used explicitly.

---

## Common NASM syntax reminders

Memory access uses brackets:

```markdown
mov rax, [rsp]       ; load 8 bytes from address rsp
mov [rsp], rax       ; store rax at address rsp
```

Immediate value:

```markdown
mov rax, 10
```

Address versus memory contents:

```markdown
mov rax, rsp         ; rax = address held in rsp
mov rax, [rsp]       ; rax = value stored at memory address rsp
```

Specify operand size when ambiguous:

```markdown
mov qword [rbp - 8], 123
mov dword [rbp - 4], 123
mov byte  [rbp - 1], 123
```

---

## Mental model summary

The stack is just memory, but `rsp`, `call`, `ret`, `push`, and `pop` give it special meaning.

Core rules:

```markdown
push x
```

means:

```markdown
rsp -= 8
[rsp] = x
```
```markdown
pop x
```

means:

```markdown
x = [rsp]
rsp += 8
```
```markdown
call f
```

means:

```markdown
push return_address
jmp f
```
```markdown
ret
```

means:

```markdown
pop return_address
jmp return_address
```

A simple stack frame is:

```markdown
push rbp
mov rbp, rsp
sub rsp, N

; function body

mov rsp, rbp
pop rbp
ret
```

And its layout is usually:

```markdown
[rbp + 8]   return address
[rbp]       old rbp
[rbp - 8]   local data
[rbp - 16]  more local data
...
```

The most important discipline is: **restore `rsp` to exactly the value it had when the function began, except for the return address that `ret` consumes.**

Here is a **Linux x86-64 NASM + libc `qsort`** example.

It sorts an array of 64-bit integers and prints the result with `printf`.

```markdown
; qsort_example.asm
;
; Build:
;   nasm -f elf64 qsort_example.asm -o qsort_example.o
;   gcc -no-pie qsort_example.o -o qsort_example
;
; Run:
;   ./qsort_example

extern qsort
extern printf

global main

section .data
    arr dq 50, 10, 40, 30, 20
    arr_len equ 5

    fmt db "%ld", 10, 0

section .text

; ------------------------------------------------------------
; int cmp_long(const void *a, const void *b)
;
; qsort passes pointers to elements:
;   rdi = pointer to first element
;   rsi = pointer to second element
;
; Since our elements are 64-bit integers:
;   [rdi] = first long
;   [rsi] = second long
;
; Return:
;   negative if a < b
;   zero     if a == b
;   positive if a > b
; ------------------------------------------------------------
cmp_long:
    mov rax, [rdi]       ; rax = *(long *)a
    mov rdx, [rsi]       ; rdx = *(long *)b

    cmp rax, rdx
    jl .less
    jg .greater

.equal:
    xor eax, eax         ; return 0
    ret

.less:
    mov eax, -1          ; return -1
    ret

.greater:
    mov eax, 1           ; return 1
    ret

; ------------------------------------------------------------
; int main(void)
; ------------------------------------------------------------
main:
    push rbp
    mov rbp, rsp

    ; qsort(arr, arr_len, sizeof(long), cmp_long)
    ;
    ; System V AMD64 ABI:
    ;   rdi = 1st argument
    ;   rsi = 2nd argument
    ;   rdx = 3rd argument
    ;   rcx = 4th argument

    mov rdi, arr         ; base pointer
    mov rsi, arr_len     ; number of elements
    mov rdx, 8           ; size of each element
    mov rcx, cmp_long    ; comparison function
    call qsort

    ; Print sorted array
    xor rbx, rbx         ; index i = 0

.print_loop:
    cmp rbx, arr_len
    jge .done

    mov rdi, fmt         ; printf format string
    mov rsi, [arr + rbx * 8]
    xor eax, eax         ; required for variadic functions like printf
    call printf

    inc rbx
    jmp .print_loop

.done:
    xor eax, eax         ; return 0 from main

    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
```

Build it:

```markdown
nasm -f elf64 qsort_example.asm -o qsort_example.o
gcc -no-pie qsort_example.o -o qsort_example
```

Run it:

```markdown
./qsort_example
```

Expected output:

```markdown
10
20
30
40
50
```

The important part is the comparator:

```markdown
cmp_long:
    mov rax, [rdi]
    mov rdx, [rsi]

    cmp rax, rdx
    jl .less
    jg .greater

    xor eax, eax
    ret
```

`qsort` does **not** pass the values directly. It passes pointers to the elements. Since the array contains `dq` values, each element is 8 bytes, so the comparator has to dereference `rdi` and `rsi` with `[rdi]` and `[rsi]`.

One ABI issue: `rbx` is callee-saved. Since `main` uses `rbx`, a stricter version should preserve it:

```markdown
main:
    push rbp
    mov rbp, rsp
    push rbx

    ; body...

.done:
    xor eax, eax
    pop rbx
    pop rbp
    ret
```

So for correctness under the calling convention, use this improved `main`:

```markdown
main:
    push rbp
    mov rbp, rsp
    push rbx

    mov rdi, arr
    mov rsi, arr_len
    mov rdx, 8
    mov rcx, cmp_long
    call qsort

    xor rbx, rbx

.print_loop:
    cmp rbx, arr_len
    jge .done

    mov rdi, fmt
    mov rsi, [arr + rbx * 8]
    xor eax, eax
    call printf

    inc rbx
    jmp .print_loop

.done:
    xor eax, eax
    pop rbx
    pop rbp
    ret
```

That is the version you should prefer.

I like your compilation commands. I want a small script that I can use to run them on an arbitrary assembly file

Create a script like this:

```markdown
#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 file.asm"
    exit 1
fi

src="$1"

if [ ! -f "$src" ]; then
    echo "Error: file not found: $src"
    exit 1
fi

base="${src%.*}"
obj="${base}.o"
exe="${base}"

nasm -f elf64 "$src" -o "$obj"
gcc -no-pie "$obj" -o "$exe"

"./$exe"
```

Save it as, for example:

```markdown
runasm
```

Make it executable:

```markdown
chmod +x runasm
```

Use it like this:

```markdown
./runasm qsort_example.asm
```

For a file named:

```markdown
qsort_example.asm
```

it will create:

```markdown
qsort_example.o
qsort_example
```

and then run:

```markdown
./qsort_example
```

A slightly cleaner version that puts build artifacts in a separate directory:

```markdown
#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 file.asm"
    exit 1
fi

src="$1"

if [ ! -f "$src" ]; then
    echo "Error: file not found: $src"
    exit 1
fi

mkdir -p build

filename="$(basename "$src")"
name="${filename%.*}"

obj="build/${name}.o"
exe="build/${name}"

nasm -f elf64 "$src" -o "$obj"
gcc -no-pie "$obj" -o "$exe"

"$exe"
```

Usage:

```markdown
./runasm qsort_example.asm
```

This version outputs:

```markdown
build/qsort_example.o
build/qsort_example
```

and runs the executable from `build/`.

You know what, I don't like bash that much. Can you do it in python? I have python 3 available

Yes. Use this as `runasm.py`:

```markdown
#!/usr/bin/env python3

import argparse
import subprocess
from pathlib import Path

def run(cmd: list[str]) -> None:
    print("+", " ".join(cmd))
    subprocess.run(cmd, check=True)

def main() -> int:
    parser = argparse.ArgumentParser(
        description="Assemble, link, and run a NASM x86-64 assembly file."
    )
    parser.add_argument("source", help="Assembly source file, e.g. qsort_example.asm")
    parser.add_argument(
        "--no-run",
        action="store_true",
        help="Build only; do not run the executable.",
    )
    parser.add_argument(
        "--pie",
        action="store_true",
        help="Link as PIE. By default, uses gcc -no-pie.",
    )
    parser.add_argument(
        "--build-dir",
        default="build",
        help="Directory for object files and executables. Default: build",
    )

    args = parser.parse_args()

    src = Path(args.source)

    if not src.is_file():
        print(f"Error: file not found: {src}")
        return 1

    build_dir = Path(args.build_dir)
    build_dir.mkdir(parents=True, exist_ok=True)

    name = src.stem
    obj = build_dir / f"{name}.o"
    exe = build_dir / name

    nasm_cmd = [
        "nasm",
        "-f",
        "elf64",
        str(src),
        "-o",
        str(obj),
    ]

    gcc_cmd = [
        "gcc",
    ]

    if not args.pie:
        gcc_cmd.append("-no-pie")

    gcc_cmd += [
        str(obj),
        "-o",
        str(exe),
    ]

    try:
        run(nasm_cmd)
        run(gcc_cmd)

        if not args.no_run:
            run([str(exe)])

    except subprocess.CalledProcessError as e:
        print(f"Command failed with exit code {e.returncode}")
        return e.returncode

    return 0

if __name__ == "__main__":
    raise SystemExit(main())
```

Use it like this:

```markdown
python3 runasm.py qsort_example.asm
```

Or make it executable:

```markdown
chmod +x runasm.py
./runasm.py qsort_example.asm
```

It will produce:

```markdown
build/qsort_example.o
build/qsort_example
```

and then run the executable.

Build without running:

```markdown
python3 runasm.py qsort_example.asm --no-run
```

Use a different build directory:

```markdown
python3 runasm.py qsort_example.asm --build-dir out
```

Link as PIE instead of using `-no-pie`:

```markdown
python3 runasm.py qsort_example.asm --pie
```