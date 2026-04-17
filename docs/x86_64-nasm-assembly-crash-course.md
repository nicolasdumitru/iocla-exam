---
title: "You said  Guide me through x86_64 NASM assembly. ..."
source: "https://gemini.google.com/app/eba24e7d80a86973"
author:
published:
created: 2026-04-17
description: "Gemini conversation with 8 messages"
tags:
  - "clippings"
---
**You**

Guide me through x86\_64 NASM assembly. I need to be able to write and understand assembly programs for a test tomorrow

---

**Gemini**

All right, let’s get you ready for this test. x86\_64 NASM (Netwide Assembler) can feel like a lot of "magic numbers" at first, but once you see the patterns, it’s just a high-stakes game of moving data between boxes.

Here is your crash course in the essentials.

---

## 1\. The Registers: Your "Workspace"

In 64-bit assembly, registers are your ultra-fast storage spots inside the CPU. Each is 64 bits (8 bytes) wide.

| Register | Common Purpose |
| --- | --- |
| **RAX** | Accumulator (used for math and return values) |
| **RBX** | Base register |
| **RCX** | Counter (loops) |
| **RDX** | Data (math/I/O) |
| **RSI** | Source Index (strings/arrays) |
| **RDI** | Destination Index (strings/arrays) |
| **RSP** | **Stack Pointer** (points to the top of the stack) |
| **RBP** | Base Pointer (points to the start of a function frame) |
| **R8 - R15** | General-purpose extra registers |

**Sub-register Sizes:** If you see `EAX`, that’s just the lower 32 bits of `RAX`. `AX` is 16 bits, and `AL` is 8 bits.

---

## 2\. Program Structure

A NASM file is divided into three main "sections":

- **`section .data`**: For initialized constants (e.g., strings, fixed numbers).
- **`section .bss`**: For uninitialized variables (reserving space).
- **`section .text`**: Where the actual code lives. You must declare `global _start` so the linker knows where to begin.

---

## 3\. Basic Instructions

In NASM, the syntax is generally: **`instruction destination, source`**

### Data Movement

- `mov rax, 10`: Put the number 10 into RAX.
- `mov rbx, rax`: Copy the value in RAX into RBX.
- `lea rdi, [var]`: **Load Effective Address**. Puts the memory address of `var` into RDI (not the value *at* that address).

### Arithmetic

- `add rax, 5`: RAX = RAX + 5
- `sub rbx, rcx`: RBX = RBX - RCX
- `inc rax` / `dec rax`: Increment or decrement by 1.
- `imul rax, rbx`: Signed multiplication.

### Control Flow (If/Then/Loops)

1. **`cmp rax, rbx`**: Compares the two (subtracts them internally and sets "flags").
2. **`je` / `jne`**: Jump if Equal / Not Equal.
3. **`jg` / `jl`**: Jump if Greater / Less.
4. **`jmp label`**: Unconditionally go to a specific part of the code.

---

## 4\. Memory Addressing

When you see square brackets `[ ]`, it means "go to this address in memory."

- `mov rax, [my_var]`: Load the value stored at `my_var` into RAX.
- `mov [rbx], rax`: Move the value in RAX into the memory address pointed to by RBX.

---

## 5\. System Calls (The Linux Way)

To actually *do* something (like print text or exit), you talk to the Kernel using a `syscall`.

1. Put the **Syscall Number** in `rax`.
2. Put arguments in `rdi`, `rsi`, `rdx` (in that order).
3. Call `syscall`.

**Common Syscalls:**

- **Exit:** `rax = 60`, `rdi = error code (0 for success)`
- **Write:** `rax = 1`, `rdi = file descriptor (1 for stdout)`, `rsi = pointer to string`, `rdx = length`

---

## 6\. A "Hello World" Template

Here is a complete, annotated program you can study:

```
section .data
    msg db "Hello, Assembly!", 10  ; 'db' means Define Bytes. 10 is a newline.
    len equ $ - msg                ; 'equ' calculates the length of the string.

section .text
    global _start

_start:
    ; --- WRITE syscall ---
    mov rax, 1      ; syscall number for sys_write
    mov rdi, 1      ; file descriptor 1 (stdout)
    mov rsi, msg    ; address of the string
    mov rdx, len    ; length of the string
    syscall         ; trigger the kernel

    ; --- EXIT syscall ---
    mov rax, 60     ; syscall number for sys_exit
    mov rdi, 0      ; return code 0
    syscall
```

---

## 7\. The Stack

The stack is a "Last-In, First-Out" (LIFO) structure in memory used for temporary storage and function calls.

- **`push rax`**: Put RAX on top of the stack and move `rsp` down.
- **`pop rbx`**: Take the top value off the stack, put it in RBX, and move `rsp` up.

> **Test Tip:** Watch out for "endianness." x86\_64 is **Little-Endian**, meaning the least significant byte is stored at the lowest address. If you're looking at memory hex dumps, things might look "backwards."

Do you have a specific practice problem or a concept like function calling conventions that you'd like to walk through?

---

**You**

Fortunately, for my test, we don't have to worry about the stack or about functions, but I am going to need more from you on structures, arrays and strings

---

**Gemini**

That simplifies things! If you don't need to worry about the stack or function calls, you can focus entirely on **memory addressing** and **data movement**.

In assembly, arrays, strings, and structures are all just blocks of contiguous memory. The only difference is how you calculate the "offset" to get to the specific byte you want.

---

## 1\. Arrays

An array is just a sequence of values of the same size. You define them in the `.data` section using `db` (1 byte), `dw` (2 bytes), `dd` (4 bytes), or `dq` (8 bytes).

### Defining Arrays

```
section .data
    my_bytes   db 10, 20, 30, 40           ; 4 bytes
    my_ints    dd 100, 200, 300            ; 3 double-words (4 bytes each)
    many_zeros times 100 dq 0              ; 100 quad-words (8 bytes each) all set to 0
```

### Accessing Elements (The Formula)

To get an element, you use **Base-Indexed-Scaling**: `[base_address + index * scale]`

- **Scale** must be 1, 2, 4, or 8 (matching the data size).
- **Example:** To get the 3rd integer (index 2) from `my_ints`:
	```
	mov eax, [my_ints + 2 * 4]  ; Move the value at (base + 8 bytes) into EAX
	```

---

## 2\. Strings

Strings are just arrays of bytes (`db`). In assembly, they are usually either **null-terminated** (end with a `0`) or have a **fixed length** defined by a constant.

### Key String Operations

While you can loop through a string manually, x86 has special instructions that use `RSI` (Source) and `RDI` (Destination):

- **`movsb` / `movsd`**: Move string byte/dword from `[RSI]` to `[RDI]`.
- **`lodsb`**: Load byte from `[RSI]` into `AL`, then increment `RSI`.
- **`stosb`**: Store byte from `AL` into `[RDI]`, then increment `RDI`.
- **`cld`**: Clear Direction Flag (makes `RSI` / `RDI` increment). **Always do this before string ops.**

**Example: Copying a string manually**

```
mov rsi, source_str
    mov rdi, dest_str
    mov rcx, 5          ; length to copy
copy_loop:
    lodsb               ; Load [rsi] into al, rsi++
    stosb               ; Store al into [rdi], rdi++
    loop copy_loop      ; Decrements rcx and jumps if rcx > 0
```

---

## 3\. Structures (struc)

A structure is just a template for memory with different-sized "holes" in it. NASM provides the `struc` macro to help you calculate the offsets without doing the math yourself.

### Defining a Structure

```
struc Person
    p_id:    resd 1    ; Reserve 1 double-word (4 bytes)
    p_age:   resb 1    ; Reserve 1 byte
    p_score: resq 1    ; Reserve 1 quad-word (8 bytes)
endstruc
```

### Using a Structure in Memory

```
section .data
    worker:
        istruc Person
            at p_id,    dd 101
            at p_age,   db 30
            at p_score, dq 95
        iend
```

### Accessing Structure Fields

You usually load the **address** of the structure into a register and then use the field names as offsets.

```
mov rbx, worker             ; RBX points to the start of the struct
mov eax, [rbx + p_id]       ; Get the ID
mov cl,  [rbx + p_age]      ; Get the Age
```

---

## Summary Table for Your Test

| Concept | Size Specifier | Scale | Pointer Syntax |
| --- | --- | --- | --- |
| **Byte** | `db` / `resb` | 1 | `byte [reg]` |
| **Word** | `dw` / `resw` | 2 | `word [reg]` |
| **D-Word** | `dd` / `resd` | 4 | `dword [reg]` |
| **Q-Word** | `dq` / `resq` | 8 | `qword [reg]` |

> **Pro-Tip:** If your test asks you to "iterate through an array," always remember to increment your pointer by the **size** of the elements (e.g., `add rsi, 4` for integers) or use the `scale` in your effective address.

Does seeing that indexing formula `[base + index * scale]` help clarify how arrays and structures are actually the same thing to the CPU?

---

**You**

Now I need you to explain conditional jumps

---

**Gemini**

Conditional jumps are the assembly version of `if` statements and loops. To understand them, you have to realize that a jump is a two-step process:

1. **The Comparison:** You perform an operation that sets "flags" in a special register called **RFLAGS**.
2. **The Jump:** You use a conditional jump instruction that looks at those flags to decide whether to change the code's execution path.

---

## 1\. The "Setup" Instructions

Before you jump, you almost always use one of these two:

- **`cmp destination, source`**: It performs a subtraction ($destination - source$) but **does not save the result**. It only updates the flags.
- **`test destination, source`**: It performs a bitwise `AND`. It's most commonly used to check if a register is zero (`test rax, rax`).

---

## 2\. The Flags (The Secret Sauce)

The CPU uses the **RFLAGS** register to keep track of what happened in the last math operation. The ones you need for your test are:

- **ZF (Zero Flag):** Set if the result was zero (meaning the two numbers were equal).
- **SF (Sign Flag):** Set if the result was negative.
- **CF (Carry Flag):** Set if an unsigned math operation "wrapped around."
- **OF (Overflow Flag):** Set if a signed math operation resulted in a number too big/small to fit.

---

## 3\. The Jump Table (Signed vs. Unsigned)

This is where most students lose points. In assembly, **signed** numbers (which can be negative) and **unsigned** numbers (only positive) use different jump instructions.

### For Signed Integers (Standard int)

| Instruction | Meaning | Condition |
| --- | --- | --- |
| **`je`** | Jump if Equal | ZF = 1 |
| **`jne`** | Jump if Not Equal | ZF = 0 |
| **`jg`** | Jump if **Greater** | ZF = 0 and SF = OF |
| **`jl`** | Jump if **Less** | SF!= OF |
| **`jge`** / **`jle`** | Greater or Equal / Less or Equal |  |

### For Unsigned Integers (Addresses, lengths, size\_t)

| Instruction | Meaning | Condition |
| --- | --- | --- |
| **`ja`** | Jump if **Above** | CF = 0 and ZF = 0 |
| **`jb`** | Jump if **Below** | CF = 1 |
| **`jae`** / **`jbe`** | Above or Equal / Below or Equal |  |

> **Mnemonic:** Use **G** reater/ **L** ess for **Signed** (think "G" for "General" integers). Use **A** bove/ **B** elow for **Unsigned** (think "A" for "Addresses").

---

## 4\. How to Structure Logic

Since assembly reads from top to bottom, you often have to "jump over" code that you don't want to execute.

### The If/Else Pattern

In C++: `if (rax == 5) { rbx = 1; } else { rbx = 0; }`

**In NASM:**

```
cmp rax, 5          ; Compare rax to 5
    jne .else_branch    ; If NOT equal, jump to the else part
    
    mov rbx, 1          ; "If" code: Set rbx to 1
    jmp .end_if         ; IMPORTANT: Jump over the else part!

.else_branch:
    mov rbx, 0          ; "Else" code: Set rbx to 0

.end_if:
    ; Code continues here...
```

---

### The Loop Pattern

In C++: `for (rcx = 10; rcx > 0; rcx--) { ... }`

**In NASM:**

```
mov rcx, 10         ; Set counter
loop_start:
    cmp rcx, 0          ; Check if counter is 0
    jle loop_done       ; If rcx <= 0, exit loop

    ; ... [Your loop body here] ...

    dec rcx             ; Decrement counter
    jmp loop_start      ; Jump back to the top

loop_done:
    ; Code continues here...
```

---

## 5\. The loop Instruction

NASM actually has a built-in instruction for simple loops. The instruction `loop label` does two things automatically:

1. Decrements `RCX` by 1.
2. Jumps to `label` if `RCX` is **not zero**.

**Warning:** It *only* uses `RCX`. If you use `loop`, make sure you aren't using `RCX` for anything else inside the loop body!

Do you want to try writing a short snippet that finds the largest number in an array, or would you rather look at how bitwise operations work?

---

**You**

Now, how does one distinguish between and create signed or unsigned values/variables?

---

**Gemini**

This is the part that trips up almost everyone: **To the CPU, a variable is just a box of bits.** It has no idea if those bits represent a signed integer, an unsigned integer, or a part of a picture of a cat.

The "type" (signed vs. unsigned) only exists in **your head** and in the **instructions** you choose to use.

---

## 1\. Creating Variables: No Difference!

When you define data in the `.data` section, you use the same directives regardless of whether you want the number to be signed or unsigned.

```
section .data
    u_val  db 255      ; Unsigned 255 or Signed -1? (Bits: 11111111)
    s_val  db -1       ; Also stored as 11111111
```

In the example above, `u_val` and `s_val` are **identical** in memory. Both are stored as `0xFF`. The CPU doesn't "tag" them. You distinguish them by how you treat them later.

---

## 2\. Two's Complement (How Sign Works)

x86\_64 uses **Two's Complement** to represent signed numbers.

- The **Most Significant Bit (MSB)** —the one furthest to the left—acts as the "sign bit."
- If the MSB is `1`, the number is negative.
- If the MSB is `0`, the number is positive.

---

## 3\. Distinguishing via Instructions

This is where the "type" actually happens. You must pick the instruction that matches your intent.

### Multiplication and Division

These are the most critical. Using the wrong one will give you a massive mathematical error.

- **Unsigned:** `mul` (Multiply), `div` (Divide)
- **Signed:** `imul` (Integer Multiply), `idiv` (Integer Divide)

### Conditional Jumps (The "A" vs "G" Rule)

As we touched on before, this is the most common place for test questions:

- **Unsigned:** Use `ja` (Above) and `jb` (Below).
- **Signed:** Use `jg` (Greater) and `jl` (Less).

---

## 4\. Widening Variables (Sign Extension)

If you move a 1-byte variable into a 4-byte register, you have to decide how to fill the "empty" space.

### For Unsigned Values (Zero Extension)

You just fill the extra space with zeros.

- **Instruction:** `movzx` (Move with Zero-Extend)
- Example: `0xFF` becomes `0x000000FF`.

### For Signed Values (Sign Extension)

You must copy the **sign bit** into all the new spaces to preserve the negative value.

- **Instruction:** `movsx` (Move with Sign-Extend)
- Example: `0xFF` (-1 as a byte) becomes `0xFFFFFFFF` (-1 as a dword).

---

## 5\. Signed/Unsigned Cheat Sheet for your Test

| Operation | Unsigned Instruction | Signed Instruction |
| --- | --- | --- |
| **Move/Extend** | `movzx` | `movsx` |
| **Multiply** | `mul` | `imul` |
| **Divide** | `div` | `idiv` |
| **Comparison** | `ja`, `jb`, `jae`, `jbe` | `jg`, `jl`, `jge`, `jle` |
| **Right Shift** | `shr` (fills with 0) | `sar` (fills with sign bit) |

> **Critical Tip:** If you see `sar` (Shift Arithmetic Right), it's a signed operation. It keeps the sign bit so that dividing a negative number by 2 stays negative. If you use `shr` on a negative number, it becomes a massive positive number!

Does the distinction between `movzx` and `movsx` make sense, or should we look at a hex example of how a negative number changes when you grow its size?