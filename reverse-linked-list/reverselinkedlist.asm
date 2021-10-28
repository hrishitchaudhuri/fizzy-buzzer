%include "utils.asm"
; stack grows from high addr to low addr
section .data
	prompt db "Enter values of nodes. One on each line:",10,0
	newline db 10,0

section .bss
	; linked list values
	head resb 8
	pre resb 8
	cur resb 8
	tmp resb 8

	; buffer values
	number resb 8
	buffer resb 16

section .text
	global _start

_start:
	; get the number from argv[1]
	; get argc. Stack is TOP->argc | &argv[0] | &argv[1] ... 
	pop rax
	cmp rax, 2
	; not enough args
	jl _exit

	; get address of argv[1]
	; number is a 0 delimited string
	pop rax
	pop rax
	call _atoi

	mov r15, [number]
	cmp r15, 0
	je _exit
insert_loop:
	mov rax, [number]
	call _itoa
	mov rax, buffer
	println

	dec r15
	cmp r15, 0
	jne insert_loop

	; got the head node
	; reverse the list
	; print out the list

	call _exit
