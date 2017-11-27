all: x86_64

boot64:
	$(MAKE) -C ./arch/x86_64

kernel64:
	$(MAKE) -C ./kernel

setaria64.img: boot64 kernel64
	cat ./arch/x86_64/bootloader.bin ./kernel/entrypoint.bin > ./setaria64.img

x86_64: setaria64.img

clean64:
	$(MAKE) -C ./arch/x86_64 clean
	$(MAKE) -C ./kernel clean
	rm -rf ./setaria64.img

clean: clean64