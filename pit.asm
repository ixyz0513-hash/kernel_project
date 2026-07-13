global PIT_HANDLER

PIT_HANDLER:
    push ax
    pushf
    
    inc word [SYSTEM_TICKS]
    
    cmp word [SYSTEM_TICKS], 100
    jge .seconds
    jmp .breaks

    .seconds:
    mov word [SYSTEM_TICKS], 0 
    inc word [SYSTEM_SECONDS]

    
    .breaks:
    mov al,0x20
    out MASTER_DATA, al
    popf
    pop ax
    iret



PIT_SETUP:
    push ax
    
    in al, SYSTEM_PORT_B
    or al, 0x3
    out SYSTEM_PORT_B,al

    pop ax
    ret


SELECT_CHANNEL_2:
    push ax

    mov al,182
    out CHANNEL_WRITE_0_2, al

    pop ax
    ret


SELECT_CHANNEL_0:
    push ax
    
    mov al, 0x36
    out CHANNEL_WRITE_0_2, al

    mov al,0x9C
    out CHANNEL_0, al

    mov al,0x2E
    out CHANNEL_0, al

    pop ax
    ret


SOUND:
    ; user parameters
    out CHANNEL_2, al
    mov al,bl
    out CHANNEL_2, al

    ret


BEEP:
    call SOUND_SET

    call PIT_SETUP

    
    call SOUND
    
    mov ax,cx
    call WAIT_TICKS

    call STOP_SOUND

    ret


SOUND_SET:
    push ax
    push bx
    
    and ax,0
    or bx,1
    and bx,1

    call SOUND

    pop ax
    pop bx
    ret


STOP_SOUND:
    push ax

    in al, 0x61        
    and al, 0xFC       
    out 0x61, al 
          
    pop ax
    ret



WAIT_SECONDS:
    push ax

    add ax, word [SYSTEM_SECONDS]
    
    .loop:
    cmp ax, word [SYSTEM_SECONDS]
    hlt
    jne .loop

    pop ax
    ret


WAIT_TICKS:
    push ax
    push bx

    mov bx, 100
    sub bx,ax
    sti

    .wait:
    cmp word [SYSTEM_TICKS], bx
    hlt
    jg .wait

    add ax, word [SYSTEM_TICKS]

    
    .loop:
    cmp ax, word [SYSTEM_TICKS]
    hlt
    jne .loop

    .breaks:
    pop bx
    pop ax
    ret
    