z.out: reverselinkedlist.o
	ld reverselinkedlist.o -o z.out

reverselinkedlist.o: reverselinkedlist.asm utils.asm
	nasm -f elf64 reverselinkedlist.asm

run: z.out
	echo "4\n5\n6\n" | ./z.out 3
