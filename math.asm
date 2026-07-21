TURN_STRING_INTO_NUMBER:
    push bp
    mov bp, sp

    push bx
    push dx
    push cx
    push si

    xor ax,ax
    xor cx,cx

    mov si, [bp + 4]
    mov bx,10
    push si
    call strlen
    cmp word [lengthstring],0
    je .breaks

    add cx,1
    sub word [lengthstring],1
    
    cmp word [lengthstring],0
    je .jmp2

    .loo:
    imul cx,bx
    dec word [lengthstring]
    
    cmp word [lengthstring],0
    jne .loo
    
    .jmp2:
    cmp [si], '-'
    jne .loop
    mov byte [IF_NEGATIVE],1
    inc si

    .loop:
    cmp [si], 0x0
    je .breaks
    
    push ax
    mov al, [si]
    sub al,0x30
    movzx dx,al
    pop ax
    
    mov [temporary1],ax
    mov ax,dx
    mul cx
    add ax, [temporary1]
    mov word [temporary1], 0
    xor dx,dx

    push ax
    mov ax,cx
    div bx
    mov cx,ax
    pop ax

    inc si
    jmp .loop 
    
    .breaks:
    cmp byte [IF_NEGATIVE],1
    jne .jmp
    neg ax

    .jmp:
    pop si
    pop cx
    pop dx
    pop bx
    pop bp
    ret