[ORG 0x00]
[BITS 64]
section .text

kernel.entry_point:
	jmp $

times 4096 - ($ - $$) db 0x00