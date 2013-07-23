USE16
org 0x7c00

start:
	mov si, sAlive	; greeting
	call lineOut	; print it
	
	; where is the stack?
	mov dx, sp
	ror dx, 8	; do high byte first
	call binHex
	call stringOut
	ror dx, 8	; now low
	call binHex
	call lineOut
	
	mov ax, 0x2401	; bios a20 enable
	int 0x15	; leaves carry set if problem
	jc a20fail	; if we can't enable a20, long mode will have a very bad time...
	
	; more to come...

halt:
	mov si, sHalt
	call lineOut
.halt:
	hlt
	jmp .halt

a20fail:
	mov si, sA20
	call lineOut
	jmp halt

lineOut:
	call stringOut
	mov si, sLine
		; fallthrough, use stringOut's ret
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

%include "binhex.asm"
	
sAlive	db	`Ahoy!\0`
sHalt	db	`Halting.\0`
sA20	db	`Failed to enable A20.\0`
sLine	db	`\r\n\0`

times 510 - ($ - $$) db 0x2b
bootSig dw 0xaa55
