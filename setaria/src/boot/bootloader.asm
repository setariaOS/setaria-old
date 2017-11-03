[ORG 0x00]
[BITS 16]

section .text

jmp 0x07C0:bootloader_start

bootloader_start:
    mov ax, 0x07C0
    mov ds, ax
    mov ax, 0xB800
    mov es, ax

    mov ax, 0x0000
    mov ss, ax
    mov sp, 0xFFFE
    mov bp, 0xFFFE

    mov si, 0

screen_clear:
    mov byte[es:si], 0
    mov byte[es:si + 1], 0x0A
    add si, 2
    cmp si, 80 * 25 * 2
    jl screen_clear

    push message_boot_start
    push 0
    push 0
    call screen_print
    add sp, 6

screen_print:
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
	mul si,
	add di, ax

    mov si, word[bp + 8]

screen_draw:
    mov cl, byte[si]
    cmp cl, 0
    je screen_draw_end
    mov byte[es:di], cl
    add si, 1
    mov di, 2
    jmp screen_draw
    
screen_draw_end:
    pop dx
    pop cx
    pop ax
    pop di
    pop si
    pop es
    pop bp
    ret

message_boot_start: db 'Booting start', 0

times 510 - ($ - $$) db 0x00
dw 0x55AA