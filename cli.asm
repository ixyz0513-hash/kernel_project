
CLI:
    push bp
    mov bp,sp
    
    push bx
    push cx
    push si
    push ax
    
    xor ax,ax
    mov ax, commands_strings
    mov si, [bp + 4]
    xor bx,bx


    .cmp:
    cmp word [command_handler + bx], 0
    je .breaks

    push ax
    push si
    call strcmp
    
    cmp byte [TRUE_FALSE_STRCMP], 1
    jne .getlength
    
    call [command_handler + bx]
    jmp .breaks
    
    
    .getlength:
    push ax
    call strlen
    mov cx, [lengthstring]
    inc cx
    add ax,cx
    add bx,2
    jmp .cmp
    

    .breaks:
    pop ax
    pop si
    pop cx
    pop bx
    pop bp

    ret 2



clear_handler:
    CLEAR_SCREEN
    mov word [cursor_x],0
    mov word [cursor_y],9
    NEWLINECLI
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

    NEWLINE 
    push ax
    call PRINT
    push ax
    call strlen
    inc word [lengthstring]
    add bx, [lengthstring]
    jmp .loop

    .breaks:
    NEWLINECLI
    pop bx
    pop ax
    ret

ver_handler:
    NEWLINE
    push kernel_version
    call PRINT
    NEWLINECLI
    ret


echo_handler:
    push ax
    NEWLINE

    mov ax, string_type
    add ax, 5
    push ax
    call PRINT

    NEWLINECLI
    pop ax
    ret