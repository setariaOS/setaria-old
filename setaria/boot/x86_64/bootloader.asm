[ORG 0x00]
[BITS 16]

section .text

jmp 0x07C0:bootloader16_start

bootloader16_start:
	mov ax, 0x07C0
	mov ds, ax
	mov ax, 0xB800
	mov es, ax

	mov si, 0

bootloader16_screen_clear:
	mov byte[es:si], 0
	mov byte[es:si + 1], 0x07
	add si, 2

	cmp si, 80 * 25 * 2
	jl bootloader16_screen_clear
	
	mov ah, 0x02
	mov bh, 0x00
	mov dh, 0x00
	mov dl, 0x00
	int 0x10
	jc bootloader16_bios_exception

	jmp bootloader16_wait

bootloader16_bios_exception:
	mov di, 0
	mov si, 0

bootloader16_bios_exception_loop:
	mov cl, byte[bootloader16_message_bios_exception + si]
	cmp cl, 0
	je bootloader16_bios_exception_loop_end

	mov byte[es:di], cl
	add si, 1
	add di, 2

	jmp bootloader16_bios_exception_loop

bootloader16_bios_exception_loop_end:
	mov ah, 0x02
	mov bh, 0x00
	mov dh, 0x00
	mov dl, 44
	int 0x10

bootloader16_wait:
	jmp $

bootloader16_message_bios_exception: 	db '[setaria] An error has occurred in the BIOS.', 0x00

times 510 - ($ - $$) 				db 0x00
db 0x55
db 0xAA