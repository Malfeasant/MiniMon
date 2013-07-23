USE16
org 0x7c00

start:
	mov si, sAlive	; greeting
	call stringOut	; print it
	
	; out of curiosity, where is the stack?
	mov dx, sp
	mov si, sHex + 4	; start at (actually past) the string's end and work back
.loop:
	dec si
	mov al, dl
	and al, 0xf
	add al, '0'
	cmp al, '9'
	jle .skip
	add al, 7	; correct for higher digits
.skip:
	mov [si], al	; put it in the buffer
	ror dx, 4	; shift bits
	cmp si, sHex	; back to the start yet?
	jne .loop
	call stringOut
	
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
sHex	db	`xxxx\r\n\0`	; buffer for a cheap bin->hex conversion

times 510 - ($ - $$) db 0x2b
bootSig dw 0xaa55
