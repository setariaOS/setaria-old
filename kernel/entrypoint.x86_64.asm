[ORG 0x00]
[BITS 64]
section .text

kernel_entry_point_start:
	mov ax, 0x0010
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ss, ax
	mov rbp, 0x0000000000008000
	mov rsp, 0x0000000000008000

	jmp kernel_entry_point_start + 0x20

times 32 - ($ - $$) db 0x00