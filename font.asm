
FONT_RENDERER:
    push bp
    mov bp,sp

    push ax
    push bx
    push cx
    push dx
    push di
    push si

    mov cx,1

    mov ax, [bp + 4]
    mov bx, 8 ; access the ascii char

    mul bx
    mov dx, font_table
    add dx, ax
    xor ax,ax

    mov al, [temporary_color]
    mov cx,8
    xor si,si

    mov bx,dx
    
    
    .loop:
    mov ah, [bx + si]

    push cx
    mov cx,8
    
    .row_loop:
    
    shl ah,1
    jnc .dont_paint

    .paint:
    mov [es:di], al

    .dont_paint:
    inc di

    .jmps:
    dec cx
    jnz .row_loop
    pop cx

    
    add di,312
    inc si
    dec cx
    jnz .loop

    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2


font_table:
     incbin "CYRILL3.F08"