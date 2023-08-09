ORG 0x7c00
BITS 16

start:
    ; Set up video mode
    mov ah, 0x0
    mov al, 0x03 ; 80x25 text mode
    int 0x10

    ; Print 'Hello world' on the screen
    mov si, hello_world ; Load the address of the string into SI
    mov ah, 0x0e ; BIOS teletype function
    
print_loop:
    lodsb ; Load the next character from the string into AL
    cmp al, 0 ; Check if the end of the string has been reached
    je done ; If so, jump to the end of the loop
    int 0x10 ; Otherwise, print the character on the screen
    jmp print_loop ; Jump back to the start of the loop

done:
    ; Infinite loop
    jmp $

hello_world db 'Hello world', 0 ; Null-terminated string

; Fill the rest of the sector with zeros
times 510-($-$$) db 0

; Boot signature
dw 0xaa55