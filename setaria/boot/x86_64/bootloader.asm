[ORG 0x00]
[BITS 16]

section .text

jmp 0x07C0:bootloader_start

bootloader_start:
	mov ax, 0x07C0
	mov ds, ax
	mov ax, 0xB800
	mov es, ax

	mov si, 0

bootloader_stack_reset:
	mov ax, 0x0000
	mov ss, ax
	mov sp, 0xFFFE
	mov bp, 0xFFFE

bootloader_screen_clear:
	mov byte[es:si], 0
	mov byte[es:si + 1], 0x07
	add si, 2

	cmp si, 80 * 25 * 2
	jl bootloader_screen_clear
	
	mov ah, 0x02
	mov bh, 0x00
	mov dh, 0x00
	mov dl, 0x00
	int 0x10
	jc bootloader_bios_exception

	jmp $

bootloader_bios_exception:
	jmp $

times 510 - ($ - $$) db 0x00
db 0x55
db 0xAA