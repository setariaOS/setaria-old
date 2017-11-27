[ORG 0x00]
[BITS 16]
section .text

jmp word 0x07C0:bootloader16_start

bootloader16_start:
	mov ax, 0x07C0
	mov ds, ax
	mov ax, 0xB800
	mov es, ax

	mov si, 0

	mov ah, 0x01
	mov ch, 0x3F
	int 0x10

bootloader16_screen_clear:
	mov byte[es:si], 0
	mov byte[es:si + 1], 0x07
	add si, 2

	cmp si, 80 * 25 * 2
	jl bootloader16_screen_clear

bootloader16_disk_read:
	mov ax, 0x0800
	mov es, ax
	mov bx, 0x0000
.loop:
	mov ah, 0x02
	mov al, 0x01
	mov ch, 0x00
	mov dh, 0x00
	mov dl, 0x00
	mov cl, byte[bootloader16_variable_sector]
	int 0x13
	jc .error
	add byte[bootloader16_variable_sector], 1

	add bx, 0x0200

	cmp byte[bootloader16_variable_sector], 10
	je bootloader16_a20_enable

	jmp .loop
.error:
	mov ax, 0xB800
	mov es, ax

	mov di, 0
	mov si, bootloader16_message_cannot_read_memory
.error_loop:
	lodsb
	or al, al
	jz .error_end

	mov byte[es:di], al
	add di, 2
	jmp .error_loop
.error_end:
	jmp $

bootloader16_a20_enable:
	mov ax, 0x2401
	int 0x15
	jc .with_scp
	jmp bootloader16_protected_mode_enable
.with_scp:
	in al, 0x92
	or al, 0x02
	and al, 0xFE
	out 0x92, al

bootloader16_protected_mode_enable:
	cli
	lgdt [bootloader32_gdtr]

	mov eax, cr0
	or eax, 0x00000001
	mov cr0, eax

	jmp $ + 2
	nop
	nop

	jmp dword 0x00000008:(bootloader32_start + 0x7C00)

bootloader16_message_cannot_read_memory: db 'Error1', 0x00
bootloader16_variable_sector: db 2

[BITS 32]
bootloader32_start:
	mov ax, 0x0010
	mov ds, ax
	mov fs, ax
	mov gs, ax

	mov ax, 0x0018
	mov es, ax

bootloader32_stack_reset:
	mov ax, 0x0010
	mov ss, ax

	mov ebp, 0x8000
	mov esp, 0x8000

bootloader32_memory_size_check:
	mov eax, 1024 * 1024 * 32 - 4
	mov dword[eax], 0x12345678
	cmp dword[eax], 0x12345678
	je bootloader32_long_mode_check
.print:
	push bootloader32_message_not_enough_memory + 0x7C00
	call bootloader32_function_string_print
	add esp, 4

bootloader32_long_mode_check:
	mov eax, 0x80000000
	cpuid
	cmp eax, 0x80000001
	jb .print

	mov eax, 0x80000001
	cpuid
	test edx, 1 << 29
	jz .print

	jmp bootloader32_page_create
.print:
	push bootloader32_message_not_supported_long_mode + 0x7C00
	call bootloader32_function_string_print
	add esp, 4

bootloader32_page_create:
	mov edi, 0x00009000
	mov dword[ds:edi], 0x0000A000 | (0x00000001 | 0x00000002)
	mov dword[ds:edi + 4], 0

	mov edi, 0x0000A000
	mov dword[ds:edi], 0x0000B000 | (0x00000001 | 0x00000002)
	mov dword[ds:edi + 4], 0

	mov edi, 0x0000B000
	mov dword[ds:edi], 0x00000001 | 0x00000002 | 0x00000080
	mov dword[ds:edi + 4], 0

bootloader32_long_mode_enable:
	mov eax, cr4
	or eax, 0x00000020
	mov cr4, eax

	mov eax, 0x00009000
	mov cr3, eax

	mov ecx, 0xC0000080
	rdmsr
	or eax, 0x00000100
	wrmsr

	mov eax, cr0
	or eax, 0xE0000000
	xor eax, 0x60000000
	mov cr0, eax

	jmp $ + 2
	nop
	nop

	lgdt [bootloader64_gdtr + 0x7C00]

	jmp dword 0x00000008:0x8000

; Arguments: Message Address
bootloader32_function_string_print:
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

bootloader32_gdtr:
	dw bootloader32_gdt_end - bootloader32_gdt - 1
	dd bootloader32_gdt + 0x7C00

bootloader32_gdt:
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
bootloader32_gdt_end:

bootloader32_message_not_enough_memory: db 'Error2', 0x00
bootloader32_message_not_supported_long_mode: db 'Error3', 0x00

[BITS 64]
bootloader64_gdtr:
	dw bootloader64_gdt_end - bootloader64_gdt - 1
	dd bootloader64_gdt + 0x7C00

bootloader64_gdt:
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
bootloader64_gdt_end:

times 510 - ($ - $$) db 0x00
db 0x55
db 0xAA