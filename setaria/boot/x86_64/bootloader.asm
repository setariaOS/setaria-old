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

bootloader16_enable_protected_mode:
	cli
	lgdt [bootloader32_gdtr]

	mov eax, cr0
	or eax, 0x00000001
	mov cr0, eax

	jmp $ + 2
	nop
	nop

	jmp dword 0x00000008:(bootloader32_start + 0x7C00)

[BITS 32]
bootloader32_start:
	mov ax, 0x0010
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	jmp $

bootloader32_gdtr:
	dw bootloader32_gdt_end - bootloader32_gdt - 1
	dd bootloader32_gdt + 0x7C00

bootloader32_gdt:
	dw 0x0000 ; Null
	dw 0x0000
	db 0x00
	db 0x00
	db 0x00
	db 0x00

	dw 0xFFFF ; Code
	dw 0x0000
	db 0x00
	db 0x9A
	db 0xCF
	db 0x00

	dw 0xFFFF ; Data
	dw 0x0000
	db 0x00
	db 0x92
	db 0xCF
	db 0x00
bootloader32_gdt_end:

times 510 - ($ - $$) db 0x00
db 0x55
db 0xAA