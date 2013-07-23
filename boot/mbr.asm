USE16
org 0x7c00

start:
	mov si, sAlive	; greeting
	call stringOut	; print it
	mov ax, 0x2401	; bios a20 enable
	int 0x15	; leaves carry set if problem
	jc a20fail	; if we can't enable a20, long mode will have a very bad time...
	
	; more to come...

halt:
	mov si, sHalt
	call stringOut
.halt:
	hlt
	jmp .halt

a20fail:
	mov si, sA20
	call stringOut
	jmp halt
	
stringOut:	; prints a null-terminated string pointed to by SI
	mov ah, 0x0e	; int 10 character out function
.loop:
	lodsb	; get char
	cmp al, 0	; test for end
	je .end
	int 0x10	; spit it out
	jmp .loop	; do it again
.end:
	ret
	
sAlive	db	`Ahoy!\r\n\0`
sHalt	db	`Halting.\r\n\0`
sA20	db	`Failed to enable A20.\r\n`

times 510 - ($ - $$) db 0x2b
bootSig dw 0xaa55
