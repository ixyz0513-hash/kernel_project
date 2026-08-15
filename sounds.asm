WARNING:
    push ax
    push bx
    push cx

    mov al, 0XFF
    mov bl, 0xFF
    mov cx, 10
    call BEEP

    mov ax,20
    call WAIT_TICKS

    mov al, 150
    mov bl, 150
    mov cx, 5
    call BEEP

    pop cx
    pop bx
    pop ax
    ret



NORMAL_SOUND:
    push ax
    push bx
    push cx


    mov al, 0XFF
    mov bl, 0xFF
    mov cx, 20
    call BEEP


    pop cx
    pop bx
    pop ax
    ret
