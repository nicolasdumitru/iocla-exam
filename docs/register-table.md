| 64-bit | 32-bit | 16-bit | 8-bit low | 8-bit high | SysV AMD64 ABI   | Windows x64 ABI  | Typical use                                           |
| ------ | ------ | ------ | --------- | ---------- | ---------------- | ---------------- | ----------------------------------------------------- |
| `rax`  | `eax`  | `ax`   | `al`      | `ah`       | caller-saved     | caller-saved     | return value, scratch                                 |
| `rbx`  | `ebx`  | `bx`   | `bl`      | `bh`       | callee-saved     | callee-saved     | preserved general-purpose                             |
| `rcx`  | `ecx`  | `cx`   | `cl`      | `ch`       | caller-saved     | caller-saved     | arg 4 in SysV, arg 1 in Windows, shift count via `cl` |
| `rdx`  | `edx`  | `dx`   | `dl`      | `dh`       | caller-saved     | caller-saved     | arg 3 in SysV, arg 2 in Windows, secondary return     |
| `rsi`  | `esi`  | `si`   | `sil`     | —          | caller-saved     | callee-saved     | arg 2 in SysV, preserved in Windows                   |
| `rdi`  | `edi`  | `di`   | `dil`     | —          | caller-saved     | callee-saved     | arg 1 in SysV, preserved in Windows                   |
| `rbp`  | `ebp`  | `bp`   | `bpl`     | —          | callee-saved     | callee-saved     | frame pointer, if used                                |
| `rsp` | `esp` | `sp` | `spl` | — | callee-restored* | callee-restored* | stack pointer |
| `r8`   | `r8d`  | `r8w`  | `r8b`     | —          | caller-saved     | caller-saved     | arg 5 in SysV, arg 3 in Windows                       |
| `r9`   | `r9d`  | `r9w`  | `r9b`     | —          | caller-saved     | caller-saved     | arg 6 in SysV, arg 4 in Windows                       |
| `r10`  | `r10d` | `r10w` | `r10b`    | —          | caller-saved     | caller-saved     | scratch                                               |
| `r11`  | `r11d` | `r11w` | `r11b`    | —          | caller-saved     | caller-saved     | scratch                                               |
| `r12`  | `r12d` | `r12w` | `r12b`    | —          | callee-saved     | callee-saved     | preserved general-purpose                             |
| `r13`  | `r13d` | `r13w` | `r13b`    | —          | callee-saved     | callee-saved     | preserved general-purpose                             |
| `r14`  | `r14d` | `r14w` | `r14b`    | —          | callee-saved     | callee-saved     | preserved general-purpose                             |
| `r15`  | `r15d` | `r15w` | `r15b`    | —          | callee-saved     | callee-saved     | preserved general-purpose                             |

\* `rsp` is the stack pointer, not an ordinary callee-saved general-purpose register. A function may adjust it internally, for example to allocate stack space, but it must restore it to the correct position before returning. In practice, the caller expects the stack to be balanced after `call`/`ret`.