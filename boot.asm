BOOT:
    push ax
    push bx
    push cx

    SETCOLOR 0x30

    mov al, 0XFF
    mov bl, 0xFF
    mov cx, 10
    call BEEP

    push bootmessage
    call PRINT_STRING_CENTER

    mov ax, 3
    call WAIT_SECONDS

    mov byte [IF_BOOT_ENDED], 1

    pop cx
    pop bx
    pop ax
    ret