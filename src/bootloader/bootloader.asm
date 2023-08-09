org 0x0 ; Set the origin to 0x0
bits 16

; Bios Parameter Block
_start:
    jmp short main ; Jump to the start of the bootloader
    nop

times 33 db 0 ; Pad the first 33 bytes with zeros (The BIOS Parameter Block other parameters)

main:
    cli ; Disable interrupts
    mov ax, 0x07c0
    mov ds, ax ; Set up data segment (We will be loading the bootloader at 0x7c00)
    mov es, ax
    mov ax, 0x0
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enable interrupts

    call print_hello_world ; Call the print_hello_world function

print_hello_world:
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