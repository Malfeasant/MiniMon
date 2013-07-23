USE16
org 0x7c00

start:
	mov si, sAlive
	call stringOut_16
.halt:
	hlt
	jmp hlt

stringOut_16:	; prints a null-terminated string pointed to by SI
	mov ah, 0x0e	; int 10 character out function
.loop:
	lodsb	; get char
	cmp al, 0	; test for end
	je .end
	int 0x10	; spit it out
	jmp short .loop	; do it again
.end:
	ret
	
sAlive	db	"Ahoy!\r\n\0"

times 510 - ($ - $$) db 0x2b
bootSig dw 0xaa55
