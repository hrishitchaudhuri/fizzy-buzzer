section .data
	; C style strings
	; length : 15 (including \n)
	text db "Tbbqolr, jbeyq",10,0

section .bss
	; reserve bytes
	buffer resb 15

section .text
	global _start

_start:
	call _setBuffer
	call _printBuffer
	jmp _exit

_setBuffer:
	; we want to move forward
	; not significant here
	cld
	; loop through all characters
	mov rcx, 15

	; set pointers to addresses
	mov r10, text
	mov r11, buffer
; process each character
start_loop:
	mov rsi, r10
	mov rdi, r10
	; loads byte into rax
	lodsb
	; advance address
	add r10, 1

	; process rax
	; capitals
	cmp rax, 65 ; less than A
	jl start_copy
	cmp rax, 90 ; greater than Z
	jg small_let 

	; rax = 'A' + (rax-'A'+13)%26
	sub rax, 65
	add rax, 13
	mov r12, 26
	cqo
	idiv r12
	mov rax, rdx
	add rax, 65

	jmp start_copy

	; small letters
small_let:
	cmp rax, 97 ; less than a
	jl start_copy
	cmp rax, 122 ; greater than z
	jg start_copy

	; rax = 'a' + (rax-'a'+13)%26
	sub rax, 97
	add rax, 13
	mov r12, 26
	cqo
	idiv r12
	mov rax, rdx
	add rax, 97

start_copy:
	mov rsi, r11
	mov rdi, r11	
	stosb
	; advance address
	add r11, 1
loop start_loop

	ret ; end of _setBuffer

; print out the result, which is stored in buffer
_printBuffer:
	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, 15
	syscall
	ret

; alt for return(0)
_exit:
	mov rax, 60
	mov rdi, 0
	syscall
