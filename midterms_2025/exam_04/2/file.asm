%include "printf32.asm"

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
section .text
global main

; arg1 = struct student_t *student
print_struct_elem:
	push ebp
	mov ebp, esp

	mov edx, [ebp + 8]

	mov ebx, [edx + id]
	PRINTF32 `ID: %d\n\x0`, ebx

	lea ebx, [edx + grades]

	PRINTF32 `Grades: \x0`

	; TODO a: Print each element of the grades[] array

	PRINTF32 `\n\x0`

	xor ebx, ebx
	mov bx, word [edx + final]
	PRINTF32 `Final: %d\n\x0`, ebx

	leave
	ret

; arg1 - grades[]
; arg2 - len
; return final
compute_final:

	; TODO b: Return final as the nearest short value of the mean of the grades array

	ret

; arg1 - struct student_t students[]
; arg2 - len
check_final_grade:

	; TODO c: Parse the students array. If the final grade is not correct, replace it with the correct value
    ; After you check each structure, print its content
    ; For this task, you have to use compute_final and print_struct_elem

	ret

main:
	push ebp
	mov ebp, esp

	; Task a
	push students
	call print_struct_elem
	add esp, 4

	; Task b
	lea ecx, [students + grades]
	push dword [count_g]
	push ecx
	call compute_final
	add esp, 8
	PRINTF32 `Computed final grade is: %d\n\x0`, eax


	; Task c
	push dword [count_s]
	push students
	call check_final_grade
	add esp, 8

	; Return 0.
	xor eax, eax
	leave
	ret
