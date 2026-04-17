section .data
	; WARNING! You must not define any new global variables.
	attack_location db "Ardhalis", 0
	read_fmt db "%d%d", 0

section .text
extern broadcast
extern scanf
global main

main:
	push rbp
	mov rbp, rsp
	
	; Align stack and reserve space for our local structure dynamically
	sub rsp, 32
	
	; TODO b: Read the month and day of the attack from the keyboard.
	lea rdi, [rel read_fmt]
	lea rsi, [rbp-4] ; month
	lea rdx, [rbp-8] ; day
	xor eax, eax
	call scanf
	
	; TODO b: Call broadcast with the correct parameters.
	; Packing the struct info into the stack (size 16 bytes: 4 byte int, 4 byte int, 8 byte char *)
	mov eax, dword [rbp-4]
	mov dword [rsp], eax ; month
	mov eax, dword [rbp-8]
	mov dword [rsp+4], eax ; day
	lea rax, [rel attack_location]
	mov qword [rsp+8], rax ; location
	
	mov rdi, rsp
	call broadcast
	
	add rsp, 32
	
	xor eax, eax
	leave
	ret
