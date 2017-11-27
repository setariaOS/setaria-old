[ORG 0x00]
[BITS 64]
section .text

kernel.entry_point:
	mov ax, 0x0010
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	jmp $