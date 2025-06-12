# For x86 NASM (calc.asm)
calc: calc.asm
	nasm -f elf32 calc.asm -o calc.o
	ld -m elf_i386 calc.o -o calc

run-calc: calc
	./calc

# For ARM GNU Assembler (calc2.asm)
calc2: calc2.asm
	as -o calc2.o calc2.asm
	ld -o calc2 calc2.o

run-calc2: calc2
	qemu-arm ./calc2

clean:
	rm -f calc calc.o calc2 calc2.o
