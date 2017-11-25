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

bootloader16.a20.enable:
	mov ax, 0x2401
	int 0x15
	jc .with_scp
	jmp bootloader16.protected_mode.enable
.with_scp:
	in al, 0x92
	or al, 0x02
	and al, 0xFE
	out 0x92, al

bootloader16.protected_mode.enable:
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

bootloader32.stack.reset:
	mov ax, 0x0010
	mov ss, ax

	mov ebp, 0x8000
	mov esp, 0x8000

bootloader32.memory.size.check:
	mov eax, 1024 * 1024 * 32 - 4
	mov dword[eax], 0x12345678
	cmp dword[eax], 0x12345678
	je bootloader32.long_mode.check
.print:
	push bootloader32.message.not_enough_memory + 0x7C00
	call bootloader32.function.string.print
	add esp, 4

bootloader32.long_mode.check:
	mov eax, 0x80000000
	cpuid
	cmp eax, 0x80000001
	jb .print

	mov eax, 0x80000001
	cpuid
	test edx, 1 << 29
	jz .print

	jmp bootloader32.page.enable
.print:
	push bootloader32.message.not_supported_long_mode + 0x7C00
	call bootloader32.function.string.print
	add esp, 4

bootloader32.page.enable:
	mov eax, 0x00009000
	push 0
	push 0x00000001 | 0x00000002
	push 0x0000A000
	push 0
	push eax
	call bootloader32.function.page.entry.set
	add esp, 20

.pml4.loop:
	add eax, 8
	push 0
	push 0
	push 0
	push 0
	push eax
	call bootloader32.function.page.entry.set
	add esp, 20
	cmp eax, 0x0000A000
	jne .pml4.loop

	jmp $

; Arguments: Message Address
bootloader32.function.string.print:
	push ebp
	mov ebp, esp
	push edi
	push esi

	mov edi, 0
	mov esi, dword[ebp + 8]
.loop:
	lodsb
	or al, al
	jz .end

	mov byte[es:edi], al
	add edi, 2
	jmp .loop
.end:
	pop esi
	pop edi
	pop ebp
	ret

; Arguments: Entry Address, Upper Base Address, Lower Base Address,
;			 Upper Flags, Lower Flags
bootloader32.function.page.entry.set:
	push ebp
	mov ebp, esp
	push eax

	mov eax, dword[ebp + 16]
	or eax, dword[ebp + 24]
	mov dword[ebp + 8], eax

	mov eax, dword[ebp + 12]
	and eax, 0x000000FF
	or eax, dword[ebp + 20]
	mov dword[ebp + 12], eax

	pop eax
	pop ebp
	ret

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
bootloader32.message.not_supported_long_mode: db '[setaria] Long-Mode is not supported.', 0x00

times 510 - ($ - $$) db 0x00
db 0x55
db 0xAA