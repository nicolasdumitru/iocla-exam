---
title: "IOCLA - Arrays and Structs in x64"
source: "https://chatgpt.com/g/g-p-6a29e0280b3081919a5ad52340278e73/c/6a2b1417-4110-83eb-84d6-de20e734a0ce"
author:
published:
created: 2026-06-12
description: "ChatGPT is your AI chatbot for everyday use. Chat with the most advanced AI to explore ideas, solve problems, and learn faster."
tags:
  - "clippings"
---
I’ll treat this from a NASM/System V x86-64 perspective, since that matches your earlier examples. I’ll focus on the memory model first, then show how indexing and field access translate into assembly.

In x64 assembly, **arrays and structs are not special runtime objects**. They are just **contiguous bytes in memory**. The CPU does not know whether those bytes represent an `int[]`, a `struct`, a string, or something else.

The meaning comes from how *you* calculate addresses.

---

## 1\. Arrays in x64 assembly

An array is a sequence of elements laid out back-to-back in memory.

For example, in C:

```markdown
int arr[4] = {10, 20, 30, 40};
```

Assuming `int` is 4 bytes, memory looks like this:

```markdown
address        value
arr + 0        10
arr + 4        20
arr + 8        30
arr + 12       40
```

So the formula for indexing is:

```markdown
address of arr[i] = base address + i * element_size
```

For an `int` array:

```markdown
arr[i] = *(arr + i * 4)
```

For a `long` or pointer array on x64:

```markdown
arr[i] = *(arr + i * 8)
```

---

## 2\. Defining arrays in NASM

Example:

```markdown
section .data
arr: dd 10, 20, 30, 40
```

Here:

```markdown
dd
```

means **define doubleword**, which is 4 bytes.

So this creates:

```markdown
arr:
    4 bytes: 10
    4 bytes: 20
    4 bytes: 30
    4 bytes: 40
```

Other common NASM data directives:

```markdown
db    ; 1 byte
dw    ; 2 bytes
dd    ; 4 bytes
dq    ; 8 bytes
```

So:

```markdown
bytes:  db 1, 2, 3
words:  dw 1000, 2000
ints:   dd 10, 20, 30
quads:  dq 100000, 200000
```

---

## 3\. Accessing array elements

Suppose:

```markdown
section .data
arr: dd 10, 20, 30, 40
```

To load `arr[0]`:

```markdown
mov eax, [arr]
```

To load `arr[1]`:

```markdown
mov eax, [arr + 4]
```

To load `arr[2]`:

```markdown
mov eax, [arr + 8]
```

Because each element is 4 bytes.

---

## 4\. Dynamic indexing

Suppose the index is in `rcx`.

For:

```markdown
x = arr[i];
```

where `arr` is an `int *`, the assembly might be:

```markdown
mov eax, [arr + rcx * 4]
```

In NASM, for a static symbol:

```markdown
mov eax, [arr + rcx*4]
```

That means:

```markdown
load 4 bytes from address arr + rcx * 4
```

So if:

```markdown
rcx = 2
```

then:

```markdown
[arr + rcx*4]
```

means:

```markdown
[arr + 8]
```

which is `arr[2]`.

---

## 5\. x64 addressing mode

x86-64 has a very useful addressing form:

```markdown
[base + index * scale + displacement]
```

Where:

```markdown
base         = register
index        = register
scale        = 1, 2, 4, or 8
displacement = constant offset
```

Examples:

```markdown
[rax]
[rax + 8]
[rax + rcx]
[rax + rcx*4]
[rax + rcx*8 + 16]
```

This is why arrays are efficient. The CPU can directly compute addresses like:

```markdown
[base + index * element_size]
```

as long as the element size is `1`, `2`, `4`, or `8`.

Example:

```markdown
; rdi = pointer to int array
; rsi = index i

mov eax, [rdi + rsi*4]
```

This implements:

```markdown
eax = arr[i];
```

assuming `arr` is in `rdi`.

---

## 6\. Byte arrays

For a byte array:

```markdown
char arr[4] = {1, 2, 3, 4};
```

NASM:

```markdown
arr: db 1, 2, 3, 4
```

Each element is 1 byte, so:

```markdown
mov al, [arr]       ; arr[0]
mov al, [arr + 1]   ; arr[1]
mov al, [arr + 2]   ; arr[2]
```

Dynamic indexing:

```markdown
; rdi = base pointer
; rsi = index

mov al, [rdi + rsi]
```

No scaling is needed because each element is 1 byte.

---

## 7\. 64-bit arrays

For an array of `long`, `uint64_t`, or pointers:

```markdown
long arr[4];
```

Each element is 8 bytes.

NASM:

```markdown
arr: dq 100, 200, 300, 400
```

Access:

```markdown
mov rax, [arr]          ; arr[0]
mov rax, [arr + 8]      ; arr[1]
mov rax, [arr + 16]     ; arr[2]
```

Dynamic indexing:

```markdown
; rdi = pointer to long array
; rsi = index

mov rax, [rdi + rsi*8]
```

---

## 8\. Arrays on the stack

Arrays can also live on the stack.

For example, this C code:

```markdown
void f(void) {
    int arr[4];
}
```

might reserve 16 bytes on the stack:

```markdown
sub rsp, 16
```

The stack space might be used like this:

```markdown
[rsp + 0]   arr[0]
[rsp + 4]   arr[1]
[rsp + 8]   arr[2]
[rsp + 12]  arr[3]
```

Example:

```markdown
sub rsp, 16

mov dword [rsp], 10
mov dword [rsp + 4], 20
mov dword [rsp + 8], 30
mov dword [rsp + 12], 40

mov eax, [rsp + 8]      ; eax = arr[2]

add rsp, 16
```

Important: stack arrays are still just contiguous memory. The only difference is that the base address is relative to `rsp` or `rbp`.

---

## 9\. Structs in x64 assembly

A struct is also just contiguous memory, but its fields may have different sizes and offsets.

For example:

```markdown
struct Point {
    int x;
    int y;
};
```

This is likely laid out as:

```markdown
offset  field
0       x
4       y
```

So:

```markdown
p.x
```

means:

```markdown
*(p + 0)
```

and:

```markdown
p.y
```

means:

```markdown
*(p + 4)
```

In assembly:

```markdown
; rdi = pointer to struct Point

mov eax, [rdi]       ; eax = p->x
mov eax, [rdi + 4]   ; eax = p->y
```

---

## 10\. Defining a struct-like object in NASM

NASM does not require a special `struct` type. You can just lay out the bytes manually:

```markdown
section .data

point:
    dd 10      ; x
    dd 20      ; y
```

Access:

```markdown
mov eax, [point]       ; x
mov eax, [point + 4]   ; y
```

This corresponds to:

```markdown
struct Point point = {10, 20};
```

---

## 11\. Struct field offsets

For this C struct:

```markdown
struct Person {
    char age;
    int height;
    long id;
};
```

You might think the layout is:

```markdown
offset 0: age    1 byte
offset 1: height 4 bytes
offset 5: id     8 bytes
```

But that is usually **not** what happens.

Compilers insert **padding** for alignment.

A typical x64 layout is:

```markdown
offset 0:  age       1 byte
offset 1:  padding   3 bytes
offset 4:  height    4 bytes
offset 8:  id        8 bytes
```

So the full size is likely 16 bytes.

In assembly:

```markdown
; rdi = pointer to struct Person

mov al,  [rdi]       ; age
mov eax, [rdi + 4]   ; height
mov rax, [rdi + 8]   ; id
```

The CPU does not know these are fields. You are just loading from offsets.

---

## 12\. Why padding exists

Modern CPUs prefer certain types to be placed at addresses aligned to their size.

Typical alignment rules on x64:

```markdown
char      1-byte alignment
short     2-byte alignment
int       4-byte alignment
long      8-byte alignment
pointer   8-byte alignment
double    8-byte alignment
```

So for:

```markdown
struct Person {
    char age;
    int height;
    long id;
};
```

The compiler puts `height` at offset `4` because an `int` prefers 4-byte alignment.

It puts `id` at offset `8` because a `long` prefers 8-byte alignment.

---

## 13\. Structs by pointer

This C code:

```markdown
void print_point(struct Point *p) {
    printf("%d\n", p->x);
}
```

If `p` is passed in `rdi`, then:

```markdown
mov eax, [rdi]
```

gets `p->x`.

For:

```markdown
p->y
```

you use:

```markdown
mov eax, [rdi + 4]
```

So:

```markdown
; rdi = pointer to struct Point

mov eax, [rdi]       ; p->x
mov edx, [rdi + 4]   ; p->y
```

---

## 14\. Structs by value

Structs can also be passed by value, but this becomes ABI-specific.

For now, the simpler mental model is:

```markdown
void f(struct Point *p);
```

means the function receives a pointer to the struct.

On Linux/macOS x86-64 System V ABI:

```markdown
rdi = first argument
rsi = second argument
rdx = third argument
rcx = fourth argument
r8  = fifth argument
r9  = sixth argument
```

So if the first argument is `struct Point *p`, then:

```markdown
rdi = address of the struct
```

Then field access is just offset access:

```markdown
mov eax, [rdi]       ; p->x
mov eax, [rdi + 4]   ; p->y
```

---

## 15\. Array of structs

Suppose you have:

```markdown
struct Point {
    int x;
    int y;
};

struct Point points[3];
```

Each `Point` is 8 bytes:

```markdown
Point size = 4 + 4 = 8
```

Memory layout:

```markdown
points + 0:   points[0].x
points + 4:   points[0].y

points + 8:   points[1].x
points + 12:  points[1].y

points + 16:  points[2].x
points + 20:  points[2].y
```

To access:

```markdown
points[i].x
```

Address formula:

```markdown
base + i * sizeof(struct Point) + offset_of(x)
```

Since `sizeof(Point) = 8` and `x` offset is `0`:

```markdown
mov eax, [rdi + rsi*8]
```

Assuming:

```markdown
rdi = base address of points
rsi = index i
```

To access:

```markdown
points[i].y
```

Use offset `4`:

```markdown
mov eax, [rdi + rsi*8 + 4]
```

That is:

```markdown
base + i * 8 + 4
```

---

## 16\. Struct containing an array

Example:

```markdown
struct Buffer {
    int length;
    char data[16];
};
```

Likely layout:

```markdown
offset 0:  length     4 bytes
offset 4:  data[0]
offset 5:  data[1]
offset 6:  data[2]
...
offset 19: data[15]
```

Access:

```markdown
; rdi = pointer to struct Buffer

mov eax, [rdi]          ; length
mov al,  [rdi + 4]      ; data[0]
mov al,  [rdi + 4 + 3]  ; data[3]
```

Dynamic index:

```markdown
; rdi = pointer to struct Buffer
; rsi = index i

mov al, [rdi + 4 + rsi]
```

That implements:

```markdown
buffer->data[i]
```

---

## 17\. Array containing pointers

Example:

```markdown
char *names[3];
```

On x64, each pointer is 8 bytes.

So:

```markdown
names[0] at names + 0
names[1] at names + 8
names[2] at names + 16
```

NASM:

```markdown
section .data

name1: db "alice", 0
name2: db "bob", 0
name3: db "charlie", 0

names:
    dq name1
    dq name2
    dq name3
```

Access `names[i]`:

```markdown
; rsi = i

mov rdi, [names + rsi*8]
```

Now `rdi` contains the pointer to the selected string.

---

## 18\. Struct containing pointers

C:

```markdown
struct Node {
    int value;
    struct Node *next;
};
```

Typical layout:

```markdown
offset 0: value     4 bytes
offset 4: padding   4 bytes
offset 8: next      8 bytes
```

So:

```markdown
; rdi = pointer to struct Node

mov eax, [rdi]       ; node->value
mov rax, [rdi + 8]   ; node->next
```

This is the kind of structure used for linked lists.

---

## 19\. Example: sum an integer array

C version:

```markdown
int sum_array(int *arr, int n) {
    int sum = 0;

    for (int i = 0; i < n; i++) {
        sum += arr[i];
    }

    return sum;
}
```

System V x86-64 calling convention:

```markdown
rdi = arr
esi = n
eax = return value
```

NASM:

```markdown
global sum_array

section .text

sum_array:
    xor eax, eax        ; sum = 0
    xor ecx, ecx        ; i = 0

.loop:
    cmp ecx, esi
    jge .done

    add eax, [rdi + rcx*4]  ; sum += arr[i]

    inc ecx
    jmp .loop

.done:
    ret
```

Key instruction:

```markdown
add eax, [rdi + rcx*4]
```

This means:

```markdown
eax = eax + *(int *)(rdi + rcx * 4)
```

---

## 20\. Example: struct field access

C:

```markdown
struct Point {
    int x;
    int y;
};

int get_y(struct Point *p) {
    return p->y;
}
```

Assembly:

```markdown
global get_y

section .text

get_y:
    mov eax, [rdi + 4]
    ret
```

Because:

```markdown
rdi     = pointer to struct Point
rdi + 0 = x
rdi + 4 = y
```

---

## 21\. Example: modify struct field

C:

```markdown
struct Point {
    int x;
    int y;
};

void set_y(struct Point *p, int value) {
    p->y = value;
}
```

Arguments:

```markdown
rdi = p
esi = value
```

Assembly:

```markdown
global set_y

section .text

set_y:
    mov [rdi + 4], esi
    ret
```

That writes 4 bytes into the struct at offset 4.

---

## 22\. Example: array of structs

C:

```markdown
struct Point {
    int x;
    int y;
};

int get_point_y(struct Point *points, int i) {
    return points[i].y;
}
```

Arguments:

```markdown
rdi = points
esi = i
```

Assembly:

```markdown
global get_point_y

section .text

get_point_y:
    movsxd rsi, esi
    mov eax, [rdi + rsi*8 + 4]
    ret
```

Explanation:

```markdown
movsxd rsi, esi
```

sign-extends the 32-bit integer index into a 64-bit register.

Then:

```markdown
[rdi + rsi*8 + 4]
```

means:

```markdown
points + i * sizeof(struct Point) + offset_of(y)
```

Since:

```markdown
sizeof(struct Point) = 8
offset_of(y) = 4
```

the address is:

```markdown
points + i * 8 + 4
```

---

## 23\. Main idea

Arrays:

```markdown
base + index * element_size
```

Structs:

```markdown
base + field_offset
```

Array of structs:

```markdown
base + index * struct_size + field_offset
```

Struct containing array:

```markdown
base + array_field_offset + index * element_size
```

Those four formulas cover most of what you need.

The CPU only sees addresses like:

```markdown
[rdi + rsi*4]
[rdi + 8]
[rdi + rsi*8 + 4]
```

It does not know the C-level type. The compiler, or you as the assembly programmer, must know the layout.