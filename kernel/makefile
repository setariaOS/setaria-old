all: entrypoint.bin

entrypoint.bin: entrypoint.asm
	nasm -o entrypoint.bin entrypoint.asm

clean:
	rm -rf ./entrypoint.bin