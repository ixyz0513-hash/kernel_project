mouse_char db 0x0
mouse_color db 0x7E
mouse_left db 0 ; if one left click happened


MOUSE_HANDLER:
    cli
    push ax
    push bx
    push cx
    pushf
    
    
    mov byte [mouse_left],0

    call CALCULATE_MOUSE_POSITION
    mov al, [mouse_char]
    mov ah, [mouse_color]
    mov di, word [cursor_position]
    stosw

    xor ax,ax
    call POLL_DATA_PORT
    
    test al,0x1 ; checking left click
    jz .jmp
    mov byte [mouse_left],1

    .jmp:
    push ax
    and al,0x10 ; checking sign bit for x
    mov cl,al ; storing it
    pop ax
    and al,0x20 ; checking sign bit for y
    mov ch,al ; storing it

    call POLL_DATA_PORT
    cmp cl,0x10
    je .jmp1
    movzx ax,al
    jmp .jmp2

    .jmp1:
    movsx ax,al
    
    .jmp2:
    add word [mouse_x],ax
    call POLL_DATA_PORT
    cmp ch,0x20
    je .jmp3
    movzx ax,al
    jmp .jmp4

    .jmp3:
    movsx ax,al


    .jmp4:
    sub word [mouse_y],ax

    call CALCULATE_MOUSE_POSITION
    mov di, [cursor_position]

    mov al, byte [es:di + 1]
    cmp al,0x30
    je .jmp5
    mov byte [mouse_color],al

    .jmp5:
    mov al, byte [es:di]
    mov byte [mouse_char],al

    mov ah, 0x30
    mov al, 0x30

    stosw

    mov al,0x20
    out SLAVE_DATA,al

    mov al,0x20
    out MASTER_DATA,al

   
    popf
    pop cx
    pop bx
    pop ax
    sti
    iret



ENABLE_WRITING_MOUSE:
    push ax

    call CAN_WRITE_TO
    mov al,0xD4
    out CONTROL_STATUS_REGISTER, al

    pop ax
    ret


ENABLE_DATA_REPORTING:

    xor ax,ax
    call ENABLE_WRITING_MOUSE

    mov al, 0xF4
    call CAN_WRITE_TO
    out DATA_PORT, al

    call POLL_DATA_PORT ; acknowledge byte
    xor ax,ax

    ret


COUNT_MODES: ; doesnt work in qemu i suppose
    xor bh,bh

    call ENABLE_WRITING_MOUSE
    mov al,0xE8
    call CAN_WRITE_TO
    out DATA_PORT,al
    call POLL_DATA_PORT

    call ENABLE_WRITING_MOUSE
    mov al,bl ; bl parameter
    call CAN_WRITE_TO
    out DATA_PORT,al
    call POLL_DATA_PORT

    xor bx,bx
    xor ax,ax
    ret
 
SAMPLE_RATE: ; doesnt work in qemu i suppose
    call ENABLE_WRITING_MOUSE
    mov al,0xF3
    call CAN_WRITE_TO
    out DATA_PORT,al
    call POLL_DATA_PORT

    call ENABLE_WRITING_MOUSE
    mov al,bl ; bl parameter
    call CAN_WRITE_TO
    out DATA_PORT,al
    call POLL_DATA_PORT

    xor bx,bx
    xor ax,ax
    ret


CAN_WRITE_TO:
    push ax

    xor ax,ax

    .loop:
    in al, CONTROL_STATUS_REGISTER
    test al,0x1
    jnz .bit0
    jmp .jmp

    .bit0:
    push ax
    in al,DATA_PORT
    pop ax

    .jmp:
    test al,0x3
    jnz .loop

    pop ax
    ret



BAT:
    cli
    xor ax,ax

    call CAN_WRITE_TO
    mov al,0x20 ; read command status byte
    out CONTROL_STATUS_REGISTER,al
    call POLL_DATA_PORT
    or al,00000010b ; enable irq12
    and al,11011111b ; clear clock low line mouse bit
    push ax
    call CAN_WRITE_TO
    mov al,0x60 ; write command status byte
    out CONTROL_STATUS_REGISTER,al
    pop ax
    call CAN_WRITE_TO
    out DATA_PORT,al
    
    call ENABLE_WRITING_MOUSE
    mov al, 0xFF
    call CAN_WRITE_TO
    out DATA_PORT, al

    call POLL_DATA_PORT ; acknowledge byte

    call POLL_DATA_PORT ; check if bat successful
    
    cmp al, 0xAA
    jne .byebye ; otherwise your cooked

    call POLL_DATA_PORT ; device id
    jmp .breaks
    
    .byebye:
    mov si, kernel_bats
    call KERNEL_PANIC

    .breaks:
    call ENABLE_DATA_REPORTING
    xor ax,ax
    xor si,si
    xor bx,bx
    sti
    ret



POLL_DATA_PORT:

    .loop:
    in al, CONTROL_STATUS_REGISTER
    test al,0x1
    jz .loop

    in al, DATA_PORT

    ret


DISABLE_MOUSE:
    push ax
   
    call CHECK_OUTPUT_BUFFER
   
    mov al, 0xA7
    out CONTROL_STATUS_REGISTER, al
   
    pop ax
    ret
   
   

ENABLE_MOUSE:
    push ax
   
    call CHECK_OUTPUT_BUFFER
  
    mov al, 0xA8
    out CONTROL_STATUS_REGISTER, al
   
    pop ax
    ret


CALCULATE_MOUSE_POSITION:
    push ax
    push word [cursor_x]
    push word [cursor_y]

    mov ax, word [mouse_x]
    mov word [cursor_x],ax

    mov ax, word [mouse_y]
    mov word [cursor_y],ax

    call CURSOR_POSITION

    pop word [cursor_y]
    pop word [cursor_x]
    pop ax