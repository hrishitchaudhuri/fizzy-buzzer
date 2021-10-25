z.out: helloworld.o
	ld helloworld.o -o z.out

helloworld.o: helloworld.asm
	nasm -f elf64 helloworld.asm
