

START_UP_PIC:
    push ax

    xor ax,ax

    mov al,0x11
    out MASTER_DATA, al
    mov al,0x1
    out 0x80, al ; delay
    
    mov al,0x20
    out MASTER_READ_DATA, al
    mov al,0x1
    out 0x80, al
    
    mov al,0x4
    out MASTER_READ_DATA, al
    mov al,0x1
    out 0x80, al 
    

    out MASTER_READ_DATA, al
    out 0x80, al

    mov al,0x11
    out SLAVE_DATA, al
    mov al,0x1
    out 0x80, al

    mov al,0x28
    out SLAVE_READ_DATA, al
    mov al,0x1
    out 0x80, al
    
    mov al,0x2
    out SLAVE_READ_DATA, al
    mov al,0x1
    out 0x80, al

    out SLAVE_READ_DATA, al
    out 0x80, al
    
    mov al, 0xFC
    out MASTER_READ_DATA, al
    mov al,0x1
    out 0x80, al
    
    mov al, 0xFF
    out SLAVE_READ_DATA, al
    mov al,0x1
    out 0x80, al

    pop ax
    ret



VECTOR_TABLE_SETUP:
    cli

    mov word [ds:0x0080], PIT_HANDLER
    mov word [ds:0x0082], cs

    mov word [ds:0x0084], KEYBOARD_HANDLER
    mov word [ds:0x0086], cs
    
    sti
    ret