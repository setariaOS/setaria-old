all: x86_64

bootloader.x86_64.bin: bootloader.x86_64.asm
	nasm -o bootloader.x86_64.bin bootloader.x86_64.asm

x86_64: bootloader.x86_64.bin

clean:
	rm -rf ./bootloader.x86_64.bin