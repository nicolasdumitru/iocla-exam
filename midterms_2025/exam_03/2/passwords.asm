section .data
	magic_number equ 42
	
	; WARNING! The following values will only be used when calling the `filter` function in main. You may not use them directly!
	raw_password dd 43, 6, 10, 4242, 82, 982, 165, 424242, 12, 8484, 4242424242, 42
	raw_password_len equ 12
	final_password times 12 dd 0
	
section .text
global main
	
; TODO c: Define the filter function.	

main:
	push ebp
	mov ebp, esp
	
	; TODO c: Call the filter function.
	
	; TODO c: Print the final password.
	
	leave
	ret

