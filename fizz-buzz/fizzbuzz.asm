section .data
	prompt db "Enter your number: ",0
	fizz db "Fizz",0
	buzz db "Buzz",0
	newline db 10,0
	
; This is all initialized to zero
section .bss
	buffer resb 16 ; to store input
	outbuf resb 16 ; to store output before it can be written
	number resb 4 ; to store n (num of fb numbers)
	
section .text
	global _start

_start:
	mov rax, prompt
	call _print
	; get n
	call _getInput
	; conv n to int
	mov rax, buffer
	call _atoi
	; loop n times
	mov r15, [number]
	cmp r15, 0
	je _exit
	; the actual number
	mov r14, 1
start_loop:
	mov rax, r14
	push rax

	mov r8, 3
	mov r9, 5

	; is div by 3?
	mov rdx, 0
	idiv r8
	cmp rdx, 0
	jne five_
	mov rax, fizz
	call _print

five_:
	pop rax
	push rax
	; is div by 5?
	mov rdx, 0
	idiv r9
	cmp rdx, 0
	jne notfive_
	mov rax, buzz
	call _print
	jmp moveon_

notfive_:
	pop rax
	push rax
	; is not div by 3?
	mov rdx, 0
	idiv r8
	cmp rdx, 0
	je moveon_
	
	pop rax
	; print out rax
	call _itoa
	mov rax, buffer
	call _print

moveon_:
	mov rax, newline
	call _print
	; setup for next iteration, if any
	inc r14
	dec r15
	cmp r15, 0
	jne start_loop

	jmp _exit

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

; clear the buffer by setting it to all zeros
_clrBuf:
	mov al, 0
	mov rsi, buffer
	mov rdi, buffer
	add rdi, 16
	stosb
	ret

; clear the number buffer by setting it to all zeros
_clrNum:
	mov al, 0
	mov rsi, number
	mov rdi, number
	add rdi, 4
	stosb
	ret

; get the number from stdin and store it in buffer
_getInput:
	call _clrBuf	
	mov rax, 0
	mov rdi, 0
	mov rsi, buffer
	syscall	
	ret

; print the text pointed to by rax. Delimited by 0
_print:
	push rax ; start of the string
	mov r10, 0 ; string length
loop_:
	mov cl, [rax]
	cmp cl, 0
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

_exit:
	mov rax, 60
	mov rdi, 0
	syscall
