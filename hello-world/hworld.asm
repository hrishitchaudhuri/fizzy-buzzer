; There are three sections in a program - 
; data, text and bss(memory for future use)
section .data
	; name given to memory loc -> text
	; db -> define bytes
	; "Hello, World" is the ascii string.
	; You can also define individual bytes by their ascii values
	; Here 10 is the ascii value of \n
	text db "Hello, World",10

section .text
	; Declaring a label global means it is accessible to the linker
	global _start

; This is a label. We can move to this point by using the label name
; Every program's execution starts from _start
_start:
	call _helloworld
	call _helloworld

	mov rax, 60	; Id of the syscall -> sys_exit
	mov rdi, 0	; First argument. error code
	syscall

; This is a subroutine, it can be "call"ed
_helloworld:
	mov rax, 1	; Id of the syscall -> sys_write here
	mov rdi, 1	; First argument. file descriptor
	mov rsi, text	; Second argument. Memory location of data to write
	mov rdx, 14	; Number of bytes to write
	; Now we call a kernel function with those arguments
	syscall

	; Go to next instruction after subroutine call
	ret
