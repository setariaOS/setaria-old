all: x86_64

boot64:
	$(MAKE) -C ./boot x86_64

kernel64:
	$(MAKE) -C ./kernel x86_64

setaria64.img: boot64 kernel64
	cat ./boot/bootloader.x86_64.bin ./kernel/entrypoint.x86_64.bin > ./setaria64.img

x86_64: setaria64.img

clean:
	$(MAKE) -C ./boot clean
	$(MAKE) -C ./kernel clean
	rm -rf ./setaria64.img