[ORG 0x00]
[BITS 64]
section .text

kernel_entrypoint_start:
	mov ax, 0x0010
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ss, ax
	mov rbp, 0x0000000000008000
	mov rsp, 0x0000000000008000

	jmp kernel_entrypoint_start + 32

times 32 - ($ - $$) db 0x00