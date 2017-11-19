all: setaria64.img

boot64:
	make -C ./boot/x86_64

setaria64.img: boot64
	cp boot/x86_64/bootloader.bin setaria64.img

clean64:
	make -C ./boot/x86_64 clean
	rm -rf ./setaria64.img

clean: clean64