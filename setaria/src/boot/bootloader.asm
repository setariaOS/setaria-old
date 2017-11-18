[ORG 0x00]
[BITS 16]

section .text

jmp 0x07C0:bootloader_start

bootloader_start:
	mov ax, 0x07C0
	mov ds, ax
	mov ax, 0xB800
	mov es, ax

	mov si, 0

bootloader_stack_reset:
	mov ax, 0x0000
	mov ss, ax
	mov sp, 0xFFFE
	mov bp, 0xFFFE

bootloader_screen_clear:
	mov byte[es:si], 0
	mov byte[es:si + 1], 0x07
	add si, 2

	cmp si, 80 * 25 * 2
	jl bootloader_screen_clear

	push bootloader_message_boot_started
	push word[bootloader_message_y]
	push 0
	call bootloader_screen_print
	add word[bootloader_message_y], 0x01
	add sp, 6

bootloader_disk_reset:
	mov ax, 0
	mov dl, 0
	int 0x13
	jc bootloader_bios_exception

	mov si, 0x1000
	mov es, si
	mov bx, 0x0000
	mov di, word[bootloader_micro_kernel_size]

	push bootloader_message_disk_reset
	push word[bootloader_message_y]
	push 0
	call bootloader_screen_print
	add word[bootloader_message_y], 0x01
	add sp, 6

bootloader_disk_read:
	cmp di, 0
	je bootloader_disk_read_end
	sub di, 0x01

	mov ah, 0x02
	mov al, 0x01
	mov ch, byte[bootloader_micro_kernel_start_track]
	mov cl, byte[bootloader_micro_kernel_start_sector]
	mov dh, byte[bootloader_micro_kernel_start_head]
	mov dl, 0x00
	int 0x13
	jc bootloader_bios_exception

	add si, 0x0020
	mov es, si

	add byte[bootloader_micro_kernel_start_sector], 0x01
	cmp al, 19
	jl bootloader_disk_read

	xor byte[bootloader_micro_kernel_start_head], 0x01
	mov byte[bootloader_micro_kernel_start_sector], 0x01
	cmp byte[bootloader_micro_kernel_start_head], 0x00
	jne bootloader_disk_read

	add byte[bootloader_micro_kernel_start_track], 0x01
	jmp bootloader_disk_read

bootloader_disk_read_end:
	push bootloader_message_micro_kernel_read
	push word[bootloader_message_y]
	push 0
	call bootloader_screen_print
	add word[bootloader_message_y], 0x01
	add sp, 6

bootloader_start_micro_kernel:
	jmp 0x1000:0x0000

bootloader_bios_exception:
	push bootloader_message_bios_exception
	push word[bootloader_message_y]
	push 0
	call bootloader_screen_print
	add word[bootloader_message_y], 0x01
	add sp, 6

	jmp $

bootloader_screen_print:
	push bp
	mov bp, sp
	push es
	push si
	push di
	push ax
	push cx
	push dx

	mov ax, 0xB800
	mov es, ax

	mov ax, word[bp + 6]
	mov si, 160
	mul si
	mov di, ax

	mov ax, word[bp + 4]
	mov si, 2
	mul si
	add di, ax

	mov si, word[bp + 8]

	mov byte[bootloader_message_x], 0x00

bootloader_screen_print_loop:
	add byte[bootloader_message_x], 0x01

	mov cl, byte[si]
	cmp cl, 0
	je bootloader_screen_print_end

	mov byte[es:di], cl
	add si, 1
	add di, 2

	jmp bootloader_screen_print_loop

bootloader_screen_print_end:
	mov ah, 0x02
	mov bh, 0x00

	cmp byte[bp + 6], 0x00
	je bootloader_screen_print_end_big
	jne bootloader_screen_print_end_little

bootloader_screen_print_end_big:
	mov dh, byte[bp + 7]
	jmp bootloader_screen_print_end_common

bootloader_screen_print_end_little:
	mov dh, byte[bp + 6]

bootloader_screen_print_end_common:
	mov dl, byte[bootloader_message_x]
	sub dl, 0x01
	int 0x10
	jc bootloader_bios_exception

	pop dx
	pop cx
	pop ax
	pop di
	pop si
	pop es
	pop bp
	ret

bootloader_message_boot_started:		db '[BOOTLOADER] Boot has started.', 0x00
bootloader_message_disk_reset:			db '[BOOTLOADER] Disk is ready.', 0x00
bootloader_message_micro_kernel_read:	db '[BOOTLOADER] Micro-Kernel has been loaded.', 0x00
bootloader_message_bios_exception:		db '[BOOTLOADER] Unknown exception occurred in BIOS.', 0x00
bootloader_message_x:					db 0x00
bootloader_message_y:					dw 0x00
bootloader_micro_kernel_size:			dw 0x0400
bootloader_micro_kernel_start_head:		db 0x00
bootloader_micro_kernel_start_track:	db 0x00
bootloader_micro_kernel_start_sector:	db 0x02

times 510 - ($ - $$)					db 0x00
db 0x55
db 0xAA