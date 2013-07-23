; handy hex conversion function
; intended for inclusion in bootsector (in other words, cheap, 16 bit, and not self-contained)
; pass the value to be converted in dl
; returns pointer to null terminated string in si
	
binHex:
	mov si, .sHex + 1
	call .conv
	ror dl, 4	; shift bits
	dec si
	call .conv
	ret
.conv:
	push dx
	and dl, 0xf
	add dl, '0'
	cmp dl, '9'
	jle .done
	add dl, 7	; correct for higher digits
.done:
	mov [si], dl	; put it in the buffer
	pop dx
	ret
	
.sHex	db	`\0\0\0`	; out buffer
