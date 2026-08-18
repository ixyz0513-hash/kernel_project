BOOT:
    sti
    MASK_KEYBOARD
    push ax
    push bx
    push cx

    call START_UP_PIC
    call VECTOR_TABLE_SETUP
    call SELECT_CHANNEL_0
    call SELECT_CHANNEL_2

    call ENABLE16_COLORSBACKGROUND
    
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

    SETCOLOR 0x7E
    call SCROLLDOWN
    call SPLIT_SCREEN
   
    call BAT


    call NEWLINE
  
    call CHECK_CONTROLER 
   
    mov al, 1
    mov bl, 12
    call CHANGEUNDERLINE

    INTRO
    call CURSOR_GO
    push message2
    call PRINT

    call NEWLINECLI

    mov word [cursor_x],3
    mov word [string_length],0 ; dont know why but it bugs out so cursor_x is at 4 maybe some character is typed before it masks the keyboard? but im just going to do this
    call CURSOR_GO

    mov word [SYSTEM_TICKS],0
    mov word [SYSTEM_SECONDS],0

    call DISPLAY_TIME

    pop cx
    pop bx
    pop ax
    UN_MASK_EVERYTHING
    ret