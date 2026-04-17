# Finding symbols
Example commands for finding all the symbols in `.bss` for an executable named
`file` (not the popular Linux command). The pattern used here is printing a symbol table and then using ripgrep to search/filter for what we need.
```bash
objdump --syms ./file | rg "\.bss"
```
```bash
nm ./file | rg " b "
```
```bash

```