CREATE_BUTTON: ; not finished yet
    MASK_KEYBOARD
    push bp
    mov bp,sp
    push si
    mov si, [bp + 4]
    push si
    call DRAWFILLED_WINDOWTEXT ; parameters passed in
    
    
    movzx si, byte [current_button]
    mov [buttons_position_x1 + si],ax
    mov [buttons_position_x2 + si],dx
    mov [buttons_position_y1 + si],bx
    mov [buttons_position_y2 + si],cx

    

    add byte [current_button],2

    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    UN_MASK_EVERYTHING
    pop si
    pop bp
    ret 2


CLEAR_BUTTONS: ; not finished yet
    push si
    push cx
    mov byte [current_button],0

    .loop:
    cmp byte [current_button],20
    jne .loop

    movzx si, byte [current_button]
    mov word [buttons_position_x1 + si],0
    mov word [buttons_position_x2 + si],0
    mov word [buttons_position_y1 + si],0
    mov word [buttons_position_y2 + si],0

    add byte [current_button],2
    jmp .loop

    mov byte [current_button],0
    pop cx
    pop si
    ret