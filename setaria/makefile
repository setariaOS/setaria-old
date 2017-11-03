all: setaria.img

boot:
	make -C ./src/boot

setaria.img: boot
	cp ./bin/boot/bootloader.bin ./bin/setaria.img

clean:
	make -C ./src/boot clean
	rm -rf ./bin