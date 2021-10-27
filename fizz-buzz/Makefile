z.out: fizzbuzz.o
	ld fizzbuzz.o -o z.out
fizzbuzz.o: fizzbuzz.asm
	nasm -f elf64 fizzbuzz.asm

run: z.out
	./z.out
