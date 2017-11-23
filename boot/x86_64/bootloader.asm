[ORG 0x00]
[BITS 16]
section .text

jmp 0x07C0:bootloader16.start

bootloader16.start:
	mov ax, 0x07C0
	mov ds, ax
	mov ax, 0xB800
	mov es, ax

	mov si, 0

	mov ah, 0x01
	mov ch, 0x3F
	int 0x10

bootloader16.screen.clear:
	mov byte[es:si], 0
	mov byte[es:si + 1], 0x07
	add si, 2

	cmp si, 80 * 25 * 2
	jl bootloader16.screen.clear

bootloader16.enable.a20:
	mov ax, 0x2401
	int 0x15
	jc .with_scp
	jmp bootloader16.enable.protected_mode
.with_scp:
	in al, 0x92
	or al, 0x02
	and al, 0xFE
	out 0x92, al

bootloader16.enable.protected_mode:
	cli
	lgdt [bootloader32.gdtr]

	mov eax, cr0
	or eax, 0x00000001
	mov cr0, eax

	jmp $ + 2
	nop
	nop

	jmp dword 0x00000008:(bootloader32.start + 0x7C00)

[BITS 32]
bootloader32.start:
	mov ax, 0x0010
	mov ds, ax
	mov fs, ax
	mov gs, ax

	mov ax, 0x0018
	mov es, ax

bootloader32.check.memory_size:
	mov eax, 1024 * 1024 * 32 - 4
	mov dword[eax], 0x12345678
	cmp dword[eax], 0x12345678
	je bootloader32.wait

	mov edi, 0
	mov esi, (bootloader32.message.not_enough_memory + 0x7C00)
.loop:
	lodsb
	or al, al
	jz bootloader32.wait

	mov byte[es:edi], al
	add edi, 2
	jmp .loop

bootloader32.wait:
	jmp $

bootloader32.gdtr:
	dw bootloader32.gdt.end - bootloader32.gdt - 1
	dd bootloader32.gdt + 0x7C00

bootloader32.gdt:
	dw 0x0000	; Null
	dw 0x0000
	db 0x00
	db 0x00
	db 0x00
	db 0x00

	dw 0xFFFF 	; Code
	dw 0x0000
	db 0x00
	db 0x9A
	db 0xCF
	db 0x00

	dw 0xFFFF 	; Data
	dw 0x0000
	db 0x00
	db 0x92
	db 0xCF
	db 0x00

	dw 0x0FA0	; Video
	dw 0x8000
	db 0x0B
	db 0x92
	db 0xC0
	db 0x00
bootloader32.gdt.end:

bootloader32.message.not_enough_memory: db '[setaria] Not enough memory. At least 32MiB of memory is required.', 0x00

times 510 - ($ - $$) db 0x00
db 0x55
db 0xAA