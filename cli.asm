
CLI:
    push bp
    mov bp,sp
    
    push dx
    push bx
    push cx
    push si
    push ax
    
    xor dx,dx
    xor ax,ax
    mov ax, commands_strings
    mov si, [bp + 4]
    xor bx,bx


    .cmp:
    cmp word [command_handler + bx], 0
    je .unkown

    cmp dx, 3
    je .jmp

    push si
    push ax
    call strcmp
    jmp .jmp2

    .jmp:
    push ax
    push si
    call strcmp

    .jmp2:
    cmp byte [TRUE_FALSE_STRCMP], 1
    jne .getlength
    
    call [command_handler + bx]
    jmp .breaks
    
    
    .getlength:
    push ax
    call strlen
    mov cx, [lengthstring]
    inc cx
    inc dx
    add ax,cx
    add bx,2
    jmp .cmp


    .unkown:
    call NEWLINE
    push message
    call PRINT
    call NEWLINECLI
    

    .breaks:
    pop ax
    pop si
    pop cx
    pop bx
    pop dx
    pop bp

    ret 2



clear_handler:
    push ax
    mov ax,28

    CLEAR_SCREEN
    mov word [cursor_y],9
    call NEWLINECLI

    cmp ax, word [NUMBERSCROLL]
    je .breaks

    .loop:
    call SCROLLSCREENUP
    cmp ax, word [NUMBERSCROLL]
    jne .loop

    .breaks:
    pop ax
    ret


help_handler:
    push ax
    push bx

    xor bx,bx
    

    .loop:
    mov ax,commands_strings
    add ax, bx
    
    cmp byte [commands_strings + bx], 0x0
    je .breaks

    call NEWLINE 
    push ax
    call PRINT
    push ax
    call strlen
    inc word [lengthstring]
    add bx, [lengthstring]
    jmp .loop

    .breaks:
    call NEWLINECLI
    pop bx
    pop ax
    ret

ver_handler:
    call NEWLINE
    push kernel_version
    call PRINT
    call NEWLINECLI
    ret


echo_handler:
    push ax
    call NEWLINE

    mov ax, string_type
    add ax, 5
    push ax
    call PRINT

    call NEWLINECLI
    pop ax
    ret



time_handler:

    call NEWLINE

    push system_seconds_str
    call PRINT

    push word [SYSTEM_SECONDS]
    call itoa
    push bufferstring
    call PRINT

    call NEWLINECLI

    ret


beep_handler:
    push ax
    push bx
    push cx
    xor ax,ax
    xor bx,bx

    mov al, 0XFF
    mov bl, 0xFF
    mov cx, 30
    call BEEP

    call NEWLINECLI
    pop cx
    pop bx
    pop ax
    ret


