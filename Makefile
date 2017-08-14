boot_print.bin: boot_print.asm
	nasm -f bin boot_print.asm -o boot_print.bin