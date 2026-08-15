
CLI:
    push bp
    mov bp,sp
    
    push bx
    push cx
    push si
    push ax

    cmp word [string_length], 1
    jle .unkown
    
    xor ax,ax
    mov ax, commands_strings
    mov si, [bp + 4]
    xor bx,bx


    .cmp:
    cmp word [command_handler + bx],0x0 
    je .unkown

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

    .unkown:
    call unkown
    jmp .breaks

    

    .breaks:
    pop ax
    pop si
    pop cx
    pop bx
    pop bp

    ret 2


    unkown:
    call NEWLINE
    push message
    call PRINT
    call NEWLINECLI
    ret


commands_strings: ; cmp for cli.asm

    db 'clear',0
    db 'help',0
    db 'ver',0
    db 'echo',0
    db 'time',0
    db 'beep',0
    db 'calc',0
    db 'stopwatch',0
    db 'textup',0
    db 0



command_handler: ; the actual functions for this will be in cli.asm

    dw clear_handler
    dw help_handler
    dw ver_handler
    dw echo_handler
    dw time_handler
    dw beep_handler
    dw calc_handler
    dw stopwatch_handler
    dw textup_handler
    dw 0