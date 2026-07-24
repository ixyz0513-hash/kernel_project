TURN_STRING_INTO_NUMBER:
    push bp
    mov bp, sp

    push bx
    push dx
    push cx
    push si

    xor ax,ax
    xor cx,cx

    cmp byte [FROM_CLI],1
    jne .jmp
    mov byte [end_character],0x20


    .jmp:
    mov si, [bp + 4]
    mov bx,10
    push si
    call strlen

    cmp [si], '-'
    jne .jmp2
    mov byte [IF_NEGATIVE],1
    inc si
    dec word [lengthstring]
    
    .jmp2:
    cmp word [lengthstring],0
    je .breaks

    

    add cx,1
    sub word [lengthstring],1
    
    cmp word [lengthstring],0
    je .loop

    .loo:
    imul cx,bx
    dec word [lengthstring]
    
    cmp word [lengthstring],0
    jne .loo

   .loop:
    mov dx, word [end_character]
    cmp [si], dx
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
    jne .jmp3
    neg ax

    .jmp3:
    mov byte [end_character],0x0
    pop si
    pop cx
    pop dx
    pop bx
    pop bp
    ret 2