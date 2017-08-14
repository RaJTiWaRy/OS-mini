; The following code is covered under the terms of The Unlicense

BITS 16
[org 0x7c00]

section .text
main:
	pusha
	; if not using org, then set ds = 0x7c0
	;mov ax, 0x7c0     ; ax = 0x7c0
	;mov ds, ax        ; ds = ax
	mov si, msg        ; load start address of msg in si
	call print_string
	call print_nl

	jmp $              ; loop at this point

	popa
	ret





; Function to print null terminated strings
print_string:
	pusha
	mov ah, 0x0e           ; set bios to teletype mode
	begin_ps:
		mov al, [si]       ; get current char
		cmp al, 0          ; check for string end
		je end_ps
		
		int 0x10           ; bios call
		inc si             ; increment address by 1
		jmp begin_ps
	end_ps:
	popa
	ret


; Function to print '\n' character followed by properly setting the cursor
print_nl:
	pusha
	mov ah, 0x0e      ; set bios to teletype mode
	mov al, 0x0a      ; load newline symbol
	int 0x10          ; bios call
	
	; The new line sets the cursor exactly below the previous
	; position. To get it back to extreme left, we use the
	; 'carriage return' ascii character 0x0d (which is hex for 13).
	; For more info, go to https://en.wikipedia.org/wiki/Carriage_return 
	mov al, 0x0d
	int 0x10          ; bios call
	popa
	ret


msg db "this is awesome!", 0

times 510-($-$$) db 0
dw 0xaa55