section .data
	; WARNING! You must not define any new global variables.
	attack_location db "Ardhalis", 0
	read_fmt db "%d%d", 0

section .text
extern broadcast
global main

main:
	push ebp
	mov ebp, esp
	
	; TODO b: Read the month and day of the attack from the keyboard.
	
	; TODO b: Call broadcast with the correct parameters.
	
	leave
	ret
