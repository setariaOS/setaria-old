all: entrypoint.x86_64.bin

entrypoint.x86_64.bin: entrypoint.x86_64.asm
	nasm -o entrypoint.x86_64.bin entrypoint.x86_64.asm

x86_64: entrypoint.x86_64.bin

clean:
	rm -rf ./entrypoint.x86_64.bin