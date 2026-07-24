
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

    
    

    



clear_handler:
    push ax
    mov ax,28

    call CLEAR_SCREEN
    mov word [cursor_y],9
    call NEWLINECLI

    cmp ax, word [NUMBERSCROLL]
    je .breaks

    .loop:
    call SCROLLSCREENUP
    cmp ax, word [NUMBERSCROLL]
    jne .loop

    .breaks:
    VERTRET_CHECK
    call DISPLAY_TIME
    pop ax
    ret


help_handler:
    push ax
    push bx
    push cx

    xor bx,bx
    xor cx,cx
    
    call NEWLINE

    mov word [cursor_x], -1
    
    .loop:
    mov ax,commands_strings
    add ax, bx
    
    cmp byte [commands_strings + bx], 0x0
    je .breaks

    cmp cx, 0x3
    jge .newline
    inc word [cursor_x]
    jmp .jmp

    .newline:
    call NEWLINE
    xor cx,cx

    .jmp:
    push ax
    call PRINT
    push ax
    call strlen
    inc word [lengthstring]
    add bx, [lengthstring]
    inc cx
    jmp .loop

    .breaks:
    call NEWLINECLI
    pop cx
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
    add ax,5
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


calc_handler:
    push si
    push ax
    push bx

    mov si, string_type
    add si,5; check if first number is there

    mov word [slowTemporary1],4

    mov ax, .call
    mov bx, .loop
    jmp short_code

    inc si
    inc word [slowTemporary1]

    .loop:
    mov ax, .jmp
    mov bx, .true
    jmp short_code
    .true:
    inc si
    inc word [slowTemporary1]
    jmp .loop

    .jmp:
    dec si
    dec word [slowTemporary1]
    add si,2 ; check if plus

    cmp byte [si],0x2B
    je .add

    cmp byte [si],0x2D
    je .sub

    cmp byte [si],0x2A
    je .multi

    cmp byte [si],0x2F
    je .divide

    .add:
    cmp byte [ADDS],1
    jne .addfalse
    add bx,ax
    jmp .print

    .addfalse:
    mov byte [ADDS],1
    jmp .jm

    .sub:
    cmp byte [SUBSTRACT],1
    jne .subfalse
    sub bx,ax
    jmp .print

    .subfalse:
    mov byte [SUBSTRACT],1
    jmp .jm

    .multi:
    cmp byte [MULTIPLY],1
    jne .multifalse
    imul bx,ax
    jmp .print

    .multifalse:
    mov byte [MULTIPLY],1
    jmp .jm

    .divide:
    cmp byte [DIVIDE],1
    jne .dividefalse
    mov [temporary1], ax 
    mov ax,bx
    mov bx, [temporary1]

    idiv bx
    mov bx,ax
    jmp .print
    
    .dividefalse:
    mov byte [DIVIDE],1


    .jm: ; haha weird label name
    add si,2 ; check if another number

    mov ax, .call
    mov bx, .jmp1
    jmp short_code

    .jmp1:
    inc si
    mov word [temporary2],1

    .loop2:
    mov ax, .jmp2
    mov bx, .true2
    jmp short_code
    .true2:
    inc si
    inc word [temporary2]
    jmp .loop2

    .jmp2:
    mov ax, [temporary2]
    sub si,ax

    mov byte [FROM_CLI],1

    sub si, word [slowTemporary1]

    xor bx,bx

    push si
    call TURN_STRING_INTO_NUMBER
    add bx,ax

    add si, word [slowTemporary1]

    mov byte [FROM_CLI],0

    push si
    call TURN_STRING_INTO_NUMBER

    cmp byte [ADDS],1
    je .add

    cmp byte [SUBSTRACT],1
    je .sub

    cmp byte [MULTIPLY],1
    je .multi

    cmp byte [DIVIDE],1
    je .divide


    .print:
    call NEWLINE
    push bx
    call itoa
    push bufferstring
    call PRINT
    
    jmp .breaks

    .call:
    call unkown
    jmp .jmp3

    .breaks:
    call NEWLINECLI
    .jmp3:
    mov byte [ADDS],0
    mov byte [SUBSTRACT],0
    mov byte [MULTIPLY],0
    mov byte [DIVIDE],0
    pop bx
    pop ax
    pop si
    ret



short_code: ; no name for this
    cmp byte [si],0x30
    jl .true

    cmp byte [si],0x39
    jg .true

    jmp bx
    .true:
    jmp ax



stopwatch_handler:
    push si
    push ax
    push bx
    mov si, string_type
    add si,10 ; check number

    mov bx, .success
    mov ax, .call
    jmp short_code
    
    .success:
    push si
    call TURN_STRING_INTO_NUMBER
    add ax, [SYSTEM_SECONDS]
    mov [TIME_WAIT],ax
    mov byte [CHECK_STOPWATCH],1

    jmp .newline


    .call:
    call unkown
    jmp .breaks

    .newline:
    call NEWLINECLI
    .breaks:
    pop bx
    pop ax
    pop si
    ret
