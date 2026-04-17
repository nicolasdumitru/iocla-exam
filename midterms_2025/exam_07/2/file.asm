%include "printf32.asm"

section .rodata
	int_fmt db "%d ", 0
	fmt_str db "%s", 10, 0
	newline db 10, 0

section .data
	question db "Do YoU wATn to PLaY a GAme?", 0
	question_len equ $-question
	arr dd 123, 456, 789, 101112, 131415
	arr_len equ $-arr

section .text

; void sum_digits(int *)
extern sum_digits

; rdi = char *str
transform_string:
	push rbp
	mov rbp, rsp

	; TODO 1: Transform lowercase characters into digits of value: 
	; question[i] = question[i] % 8 + '0', where c is the ascii value of the character
	; test using question
	test rdi, rdi
	jz .done

.loop:
	mov al, byte [rdi]
	test al, al
	jz .done
	
	cmp al, 'a'
	jl .next
	cmp al, 'z'
	jg .next
	
	; lowercase letter - al % 8 -> and al, 7
	and al, 7
	add al, '0'
	mov byte [rdi], al
	
.next:
	inc rdi
	jmp .loop
	
.done:
	leave
	ret

; void apply_digit_sum(int *arr, int size)
; rdi = arr, rsi = size
apply_digit_sum:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14

	; TODO 2: Apply the sum_digits function to each element of the array
	mov r12, rdi
	mov r13, rsi
	xor r14, r14 ; index

.loop_b:
	cmp r14d, r13d
	jge .done_b
	
	lea rdi, [r12 + r14 * 4]
	call sum_digits
	
	inc r14
	jmp .loop_b
	
.done_b:
	pop r14
	pop r13
	pop r12

	leave
	ret

global main
extern printf

main:
	push rbp
	mov rbp, rsp
	push r12

	; TODO 1: Call transform_string using the `question` string
	lea rdi, [rel question]
	call transform_string
	
	lea rdi, [rel fmt_str]
	lea rsi, [rel question]
	xor eax, eax
	call printf

	; TODO 2: Call apply_digit_sum using the `arr` array
	lea rdi, [rel arr]
	mov rsi, 5 ; arr_len is 5 ints
	call apply_digit_sum

	; TODO 3: Allocate a 5 integer array on the stack and call sum_digits on it
	; print out the elements of the array using printf
	sub rsp, 32
	mov dword [rsp], 45
	mov dword [rsp+4], 64
	mov dword [rsp+8], 911
	mov dword [rsp+12], 1234
	mov dword [rsp+16], 52344
	
	mov rdi, rsp
	mov rsi, 5
	call apply_digit_sum
	
	xor r12, r12
.print_loop:
	cmp r12, 5
	jge .print_done
	
	movsxd rsi, dword [rsp + r12 * 4]
	lea rdi, [rel int_fmt]
	xor eax, eax
	call printf
	inc r12
	jmp .print_loop
	
.print_done:
	lea rdi, [rel fmt_str]
	lea rsi, [rel newline]
	xor eax, eax
	call printf
	
	add rsp, 32

	pop r12
	xor eax, eax
	leave
	ret
