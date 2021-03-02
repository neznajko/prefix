PRO = prefix
OBJ = ${PRO}.o
SRC = ${PRO}.asm
LNK = gcc -gdwarf

a.out: ${OBJ} 
	${LNK} $^
${OBJ}: ${SRC}
	nasm -f elf64 -g -F dwarf $<

.PHONY: clean
clean:
	$(RM) ${OBJ} a.out
