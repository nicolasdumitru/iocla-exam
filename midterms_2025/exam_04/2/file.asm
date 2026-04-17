extern printf

; the structure for a student
struc student_t
	id: resd 1 ; integer - the id of the student
	grades: resw 3    ; grades[3] - student's grade
	final: resw 1     ; short - grades
endstruc

section .data
	count_s: dd 3 ; number of entries
	count_g: dd 3 ; number of elements in the `grades` array

	students:
		istruc student_t
			at id, dd 123456
			at grades, dw 10, 9, 4
			at final, dw 3
		iend

		istruc student_t
			at id, dd 123457
			at grades, dw 9, 9, 8
			at final, dw 9
		iend

		istruc student_t
			at id, dd 123458
			at grades, dw 10, 8, 10
			at final, dw 0
		iend
		
	fmt_id db "ID: %d", 10, 0
	fmt_grades_hdr db "Grades: ", 0
	fmt_grade db "%hd ", 0
	fmt_nl db 10, 0
	fmt_final db "Final: %d", 10, 0
	fmt_computed db "Computed final grade is: %d", 10, 0

section .text
global main

; arg1 = struct student_t *student
print_struct_elem:
	push rbp
	mov rbp, rsp
	push rbx
	push r12

	mov rbx, rdi ; save student pointer
	
	lea rdi, [rel fmt_id]
	mov esi, dword [rbx + id]
	xor eax, eax
	call printf
	
	lea rdi, [rel fmt_grades_hdr]
	xor eax, eax
	call printf
	
	; TODO a: Print each element of the grades[] array
	mov r12, 3
	xor rcx, rcx
.loop_a:
	cmp rcx, r12
	jge .done_a
	
	lea rdi, [rel fmt_grade]
	movsx rsi, word [rbx + grades + rcx * 2]
	xor eax, eax
	
	push rcx ; preserve
	call printf
	pop rcx
	
	inc rcx
	jmp .loop_a
.done_a:
	lea rdi, [rel fmt_nl]
	xor eax, eax
	call printf
	
	lea rdi, [rel fmt_final]
	movsx rsi, word [rbx + final]
	xor eax, eax
	call printf
	
	pop r12
	pop rbx
	leave
	ret

; arg1 - grades[]
; arg2 - len
; return final
compute_final:
	push rbp
	mov rbp, rsp
	
	xor rcx, rcx
	xor rax, rax ; sum
	
.loop_b:
	cmp rcx, rsi
	jge .done_b
	
	movsx rdx, word [rdi + rcx * 2]
	add rax, rdx
	
	inc rcx
	jmp .loop_b
.done_b:
	; TODO b: Return final as the nearest short value of the mean of the grades array
	; (sum + len/2) / len
	mov rcx, rsi
	shr rcx, 1
	add rax, rcx
	
	cqo
	idiv rsi

	leave
	ret

; arg1 - struct student_t students[]
; arg2 - len
check_final_grade:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	
	mov r12, rdi ; students pointer
	mov r13, rsi ; len
	xor r14, r14 ; index
	
.loop_c:
	cmp r14, r13
	jge .done_c
	
	; compute student addr: students + idx * 12
	mov rax, r14
	imul rax, 12
	add rax, r12
	mov rdi, rax ; student pointer
	push rdi ; save student pointer
	
	; calculate final
	lea rdi, [rax + grades]
	mov rsi, 3
	call compute_final
	
	pop rdi
	
	; TODO c: Parse the students array. If the final grade is not correct, replace it with the correct value
	movsx rdx, word [rdi + final]
	cmp eax, edx
	je .ok_c
	
	mov word [rdi + final], ax
.ok_c:
	call print_struct_elem
	
	inc r14
	jmp .loop_c
.done_c:
	pop r14
	pop r13
	pop r12
	leave
	ret

main:
	push rbp
	mov rbp, rsp

	; Task a
	lea rdi, [rel students]
	call print_struct_elem

	; Task b
	lea rdi, [rel students + grades]
	movsx rsi, dword [rel count_g]
	call compute_final
	
	lea rdi, [rel fmt_computed]
	mov esi, eax
	xor eax, eax
	call printf

	; Task c
	lea rdi, [rel students]
	movsx rsi, dword [rel count_s]
	call check_final_grade

	; Return 0
	xor eax, eax
	leave
	ret
