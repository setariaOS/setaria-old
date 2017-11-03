all: setaria.img

boot:
	make -C ./src/boot

setaria.img: boot
	cp ./src/boot/bootloader.bin ./setaria.img

clean:
	make -C ./src/boot clean
	rm -rf ./setaria.img