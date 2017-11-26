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

bootloader16.disk.read:
	mov ax, 0x0000
	mov es, ax
	mov bx, 0x8000
.loop:
	mov ah, 0x02
	mov al, 0x01
	mov ch, 0x00
	mov dh, 0x00
	mov dl, 0x00
	mov cl, byte[bootloader16.variable.sector]
	int 0x13
	jc .error
	add byte[bootloader16.variable.sector], 1

	add si, 512
	mov es, si

	cmp byte[bootloader16.variable.sector], 10
	je bootloader16.a20.enable

	jmp .loop
.error:
	mov ax, 0xB800
	mov es, ax

	mov di, 0
	mov si, bootloader16.message.cannot_read_memory
.error.loop:
	lodsb
	or al, al
	jz .error.end

	mov byte[es:di], al
	add di, 2
	jmp .error.loop
.error.end:
	jmp $

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

bootloader16.message.cannot_read_memory: db 'E1', 0x00
bootloader16.variable.sector: db 2

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

	jmp bootloader32.page.create
.print:
	push bootloader32.message.not_supported_long_mode + 0x7C00
	call bootloader32.function.string.print
	add esp, 4

bootloader32.page.create:
	mov edi, 0x00009000
	mov dword[ds:edi], 0x0000A000 | (0x00000001 | 0x00000002)
	mov dword[ds:edi + 4], 0

	mov edi, 0x0000A000
	mov dword[ds:edi], 0x0000B000 | (0x00000001 | 0x00000002)
	mov dword[ds:edi + 4], 0

	mov edi, 0x0000B000
	mov dword[ds:edi], 0x00000001 | 0x00000002 | 0x00000080
	mov dword[ds:edi + 4], 0

bootloader32.long_mode.enable:
	mov eax, cr4
	or eax, 0x00000020
	mov cr4, eax

	mov eax, 0x00009000
	mov cr3, eax

	lgdt [bootloader64.gdtr]

	mov ecx, 0xC0000080
	rdmsr
	or eax, 0x00000100
	wrmsr

	mov eax, cr0
	or eax, 0xE0000000
	xor eax, 0x60000000
	mov cr0, eax
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

bootloader32.message.not_enough_memory: db 'E2', 0x00
bootloader32.message.not_supported_long_mode: db 'E3', 0x00

[BITS 64]
bootloader64.gdtr:
	dw bootloader64.gdt.end - bootloader64.gdt - 1
	dd bootloader64.gdt + 0x7C00

bootloader64.gdt:
	dw 0x0000	; Null
	dw 0x0000
	db 0x00
	db 0x00
	db 0x00
	db 0x00

	dw 0xFFFF	; Code
	dw 0x0000
	db 0x00
	db 0x9A
	db 0xAF
	db 0x00

	dw 0xFFFF	; Data
	dw 0x0000
	db 0x00
	db 0x92
	db 0xAF
	db 0x00
bootloader64.gdt.end:

times 510 - ($ - $$) db 0x00
db 0x55
db 0xAA