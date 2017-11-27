[ORG 0x00]
[BITS 64]
section .text

kernel_entry_point:
	mov ax, 0x0010
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	jmp 0x0000000000008020

times 32 - ($ - $$) db 0x00