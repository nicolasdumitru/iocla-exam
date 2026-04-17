section .data
	magic_number equ 42
	
	; WARNING! The following values will only be used when calling the `filter` function in main. You may not use them directly!
	raw_password dd 43, 6, 10, 4242, 82, 982, 165, 424242, 12, 8484, 4242424242, 42
	raw_password_len equ 12
	final_password times 12 dd 0
	
	print_fmt db "%u ", 0
	newline db 10, 0

section .text
extern printf
global main
	
; TODO c: Define the filter function.	
; int filter(int *src_array, int src_array_len, int *dest_array);
; rdi = src_array, esi = src_array_len, rdx = dest_array
filter:
	push rbp
	mov rbp, rsp
	
	mov r11, rdx ; save dest_array to r11 to avoid clobber
	xor r8d, r8d ; count of matched elements
	xor rcx, rcx ; current index
.loop:
	cmp ecx, esi
	jge .done
	
	mov eax, dword [rdi + rcx * 4]
	mov r9d, eax
	
	xor edx, edx
	mov r10d, 42
	div r10d
	
	test edx, edx
	jnz .skip
	
	mov dword [r11 + r8 * 4], r9d
	inc r8d
.skip:
	inc ecx
	jmp .loop
.done:
	mov eax, r8d
	leave
	ret

main:
	push rbp
	mov rbp, rsp
	
	; TODO c: Call the filter function.
	lea rdi, [rel raw_password]
	mov esi, raw_password_len
	lea rdx, [rel final_password]
	call filter
	
	; TODO c: Print the final password.
	mov r12d, eax ; length
	xor r13d, r13d ; index
	
.print_loop:
	cmp r13d, r12d
	jge .print_done
	
	lea rsi, [rel final_password]
	mov esi, dword [rsi + r13 * 4]
	lea rdi, [rel print_fmt]
	xor eax, eax
	call printf
	
	inc r13d
	jmp .print_loop
.print_done:
	lea rdi, [rel newline]
	xor eax, eax
	call printf
	
	xor eax, eax
	leave
	ret
