%include "utils.asm"
; stack grows from high addr to low addr
section .data
	prompt db "Enter values of nodes. One per line:",10,0
	newline db 10,0
	space db " ",0

section .bss
	; linked list values
	head resb 8
	pre resb 8
	cur resb 8
	tmp resb 8

	; buffer values
	newnode resb 8
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

	; allocate head
	call _allocNode
	movPtr [head], [newnode]
	movPtr [tmp], [head]

	mov r15, [number]
	cmp r15, 0
	je _exit

	mov rax, prompt
	call _print

	; build the list
insert_loop:
	push r15
	call _getInput
	mov rax, buffer
	call _atoi
	mov rax, [number]

	; tmp->next = new node();
	; tmp = tmp->next
	; tmp->val = val
	; tmp->next = 0
	call _allocNode
	mov rdx, [tmp] ; rdx = tmp
	lea rdx, [rdx+8] ; rdx = rdx+8 (ptr to next)
	movPtr [rdx], [newnode] ; *(tmp).next = new node()
	movPtr [tmp], [rdx] ; tmp = *(tmp).next
	mov rdx, [rdx]
	
	movVal [rdx], [number] ; tmp->val = val

	; printNode rdx

	lea rdx, [rdx+8]
	movPtr [rdx], 0 ; tmp->next = 0

	pop r15
	dec r15
	cmp r15, 0
	jne insert_loop

	; print list
	movNxt [cur], [head]
prnLoop:
	printNode [cur]
	mov rax, newline
	call _print
	movNxt [cur], [cur]
	mov r14, [cur]
	mov r15, 0
	cmp r14, r15
	jne prnLoop

	call _exit

	; reverse the list
	movPtr [pre], [head] ; pre = head
	movNxt [cur], [head] ; cur = head->next
revLoop:
	printNode [tmp]
	movNxt [tmp], [cur] ; tmp = cur->next
	movNxtAlt [cur], [pre] ; cur->next = pre
	movPtr [pre], [cur] ; pre = cur
	movPtr [cur], [tmp] ; cur = tmp
	movNxt r15, [cur]
	cmp r15, 0
	jne revLoop

	mov rax, newline
	call _print

	call _exit
	
	; print out the list
	movPtr [cur], [pre]
printLoop:
	; print out cur->val
	printNode [cur]

	movNxt [cur], [cur]
	cmpPtr [cur], [head]
	jne printLoop ; loop till cur == head
	
	mov rax, newline
	call _print

	call _exit

; allocate memory for a new node & store in newnode
; simple memory management since we are not deleting nodes
; therefore no need to take care of internal fragm.
_allocNode:
	mov rax, 12 ; sys_brk
	mov rdi, 0
	syscall ; sys_brk(0) get cur brk loc
	mov qword [newnode], rax

	lea rdi, [rax+NODESIZE]
	mov rax, 12
	syscall ; sys_brk(old_loc + space for new node)
	ret
