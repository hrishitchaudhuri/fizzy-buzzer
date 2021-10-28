; Utilities for reverselinkedlist.asm
STDIN   equ 0
STDOUT  equ 1
STDERR  equ 2

; exit(0)
_exit:
	mov rax, 60
	mov rdi, 0
	syscall
	ret

; convert the string in rax to an int & store in number
_atoi:
	mov r11, rax
	call _clrNum
	; used to build up the integer
	; rax is the only reg used by mul
	xor rax, rax
	; constant 10 because mul doesn't allow operand to be a value o.O
	mov r13, 10
loop1_:
	xor r12, r12
	mov r12b, [r11]
	cmp r12b, 0
	je loop1_end
	cmp r12b, 10
	je loop1_end
	sub r12, 48 ; conversion from ascii
	inc r11
	mul r13
	add rax, r12
	jmp loop1_	
loop1_end:
	mov [number], rax
	ret

; clear the number buffer by setting it to all zeros
_clrNum:
	mov al, 0
	mov rsi, number
	mov rdi, number
	add rdi, 8
	stosb
	ret

; convert value in rax to string and store in buffer
_itoa:
	; modulus
	mov r10, 10
	; number of chars
	mov r11, 0

; place digits onto stack
loop2_:
	mov rdx, 0
	idiv r10
	push rdx
	inc r11
	cmp rax, 0
	jne loop2_

; addr of next write loc in buffer
	mov r10, buffer
; pop off chars and move to buffer
loop3_:
	pop r12
	add r12, 48 ; convert to ascii repr
	mov [r10], r12 ; write to buffer
	inc r10
	dec r11
	cmp r11, 0
	jne loop3_
	mov r12, 0
	mov [r10], r12 ; the delimiter
	ret

; print the text pointed to by rax. Delimited by 0
_print:
	push rax ; start of the string
	mov r10, 0 ; string length
loop_:
	mov bl, [rax]
	cmp bl, 0
	je loop_end
	inc rax
	inc r10
	jmp loop_
loop_end:

	mov rax, 1
	mov rdi, 1
	pop rsi
	mov rdx, r10
	syscall

	ret

%macro println 0
	call _print
	mov rax, newline
	call _print
%endmacro
