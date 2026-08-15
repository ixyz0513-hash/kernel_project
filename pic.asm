MASTER_DATA equ 0x20
MASTER_READ_DATA equ 0x21

SLAVE_DATA equ 0xA0
SLAVE_READ_DATA equ 0xA1

START_UP_PIC:
    push ax

    xor ax,ax

    ;icw1
    mov al,0x11
    out MASTER_DATA, al
    mov al,0x1
    out 0x80, al ; delay
    
    ;icw2
    mov al,0x20
    out MASTER_READ_DATA, al
    mov al,0x1
    out 0x80, al
    
    ;icw3
    mov al,0x4
    out MASTER_READ_DATA, al
    mov al,0x1
    out 0x80, al 
    
    ;icw4
    out MASTER_READ_DATA, al
    out 0x80, al

    ;icw1
    mov al,0x11
    out SLAVE_DATA, al
    mov al,0x1
    out 0x80, al

    ;icw2
    mov al,0x28
    out SLAVE_READ_DATA, al
    mov al,0x1
    out 0x80, al
    
    ;icw3
    mov al,0x2
    out SLAVE_READ_DATA, al
    mov al,0x1
    out 0x80, al

    ;icw4
    out SLAVE_READ_DATA, al
    out 0x80, al
    
    mov al, 0xF8 ; ir0 ir1 ir2 = 0
    out MASTER_READ_DATA, al
    mov al,0x1
    out 0x80, al
    
    mov al, 0xEF ; ir12 = 0
    out SLAVE_READ_DATA, al
    mov al,0x1
    out 0x80, al

    pop ax
    ret



VECTOR_TABLE_SETUP:
    cli

    mov word [0x0080], PIT_HANDLER
    mov word [0x0082], cs

    mov word [0x0084], KEYBOARD_HANDLER
    mov word [0x0086], cs

    mov word [0x00B0], MOUSE_HANDLER
    mov word [0x00B2], cs
    
    sti
    ret
