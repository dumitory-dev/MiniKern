org 0x7c00                  ; Origin address for the bootloader
bits 16                     ; Bootloader operates in 16-bit real mode initially

; Constants for segment offsets
CODE_SEG equ code_segment - gdt_start
DATA_SEG equ data_segment - gdt_start

; BIOS Parameter Block and initial jump
_start:
    jmp 0:main             ; Jump to main to start the bootloader
times 33 db 0              ; Padding for the BIOS Parameter Block

; Main bootloader routine
main:
    cli                    ; Disable interrupts
    xor ax, ax             ; Clear AX (more efficient than mov ax, 0)
    mov ds, ax             ; Initialize DS, ES, SS to 0
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00         ; Initialize stack pointer to 0x7c00
    sti                    ; Enable interrupts

; Load GDT and transition to protected mode
load_into_protected_mode:
    cli                    ; Disable interrupts
    lgdt [gdt_descriptor]  ; Load the Global Descriptor Table

    mov eax, cr0           ; Move contents of CR0 into EAX
    or eax, 1              ; Set PE bit to enable protected mode
    mov cr0, eax           ; Write back to CR0

    ; Enable A20 line for addressing beyond 1MB
    in al, 0x92            ; Read from port 0x92
    or al, 2               ; Set the A20 bit
    out 0x92, al           ; Write back to port 0x92

    jmp CODE_SEG:main_32   ; Far jump to flush CPU queue and enter protected mode

; Global Descriptor Table
gdt_start:
zero_descriptor:           ; Null descriptor
    dd 0x0
    dd 0x0

; Code segment descriptor
code_segment:              ; CS descriptor
    dw 0xffff
    dw 0x0
    db 0x0
    db 0x9a                ; Access byte
    db 0xcf                ; Limit (high)
    db 0x0

; Data segment descriptor
data_segment:              ; DS, ES, FS, GS, SS descriptor
    dw 0xffff
    dw 0x0
    db 0x0
    db 0x92                ; Access byte
    db 0xcf                ; Limit (high)
    db 0x0

gdt_end:
gdt_descriptor:            ; GDT descriptor
    dw gdt_end - gdt_start - 1
    dd gdt_start

; Protected mode code segment
bits 32
main_32:
    mov ax, DATA_SEG
    mov ds, ax             ; Initialize data segments
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000    ; Set stack base
    mov esp, ebp           ; Set stack pointer
    jmp $                  ; Infinite loop

; Boot sector padding and signature
times 510-($-$$) db 0
dw 0xaa55                  ; Boot signature
