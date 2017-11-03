all: bootloader.bin

bootloader.bin: bootloader.asm
	nasm -o bootloader.bin bootloader.asm
	mv -f bootloader.bin ../../bin/boot/bootloader.bin

clean:
	rm -rf ../../bin/boot