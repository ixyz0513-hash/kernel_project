DISPLAY_TIME:

   mov ax,50
   mov dx,79
   mov bx,0
   mov cx,4
   call DRAWFILLED_WINDOW

   push word [current_color]
   mov ax, [shadow_color]
   mov [current_color],ax

   mov ax, 51
   mov bx, 2
   push system_seconds_str
   call PRINT_STRING_AT

   
   push word [SYSTEM_SECONDS]
   call itoa

   mov ax,67 ; HAHAHAHAH SO FUNNY :( 
   mov bx,2
   push bufferstring
   call PRINT_STRING_AT

   pop word [current_color]
   
   xor cx,cx
   xor bx,bx
   xor ax,ax
   xor dx,dx
   
   ret



KERNEL_PANIC:
     MASK_KEYBOARD

     mov word [current_color], 0x41 ; background red and foreground blue
     call CLEAR_SCREEN

     push kernel_error
     push si ; set before the function/label
     call strcat


     xor ax,ax
     xor bx,bx
     push valcpy
     call PRINT_STRING_AT

     call WARNING
     
     cli

     .loop:
     hlt
     jmp .loop

quote_value dw 0x0     

TEXT_POP_UP:

   mov byte [IF_FROM_TEXTUP],1

   mov ax,0
   mov dx,40
   mov bx,0
   mov cx,4
   call DRAWFILLED_WINDOW


   push word [current_color]

   mov ax, [shadow_color]
   mov [current_color],ax

   push word [cursor_x]
   push word [cursor_y]

   xor cx,cx

   mov si,messages_handler

   .loop:
   cmp [quote_value],cx
   je .jmp

   push si
   call strlen
   mov bx, [lengthstring]
   inc bx
   add si,bx
   inc cx
   jmp .loop
   
   .jmp:
   mov word [cursor_x], 1
   mov word [cursor_y], 1
   push si
   call PRINT

   pop word [cursor_y]
   pop word [cursor_x]
   pop word [current_color]

   inc word [quote_value]
   cmp word [quote_value], 0x4
   je .zero
   jmp .breaks

   .zero:
   mov word [quote_value],0x0

   .breaks:
   mov byte [IF_FROM_TEXTUP],0
   xor cx,cx
   xor bx,bx
   xor ax,ax
   xor dx,dx
   xor si,si
   
   ret

messages_handler:
    db 'Life is like riding a bicycle. To keep your balance, you must keep moving.',0
    db 'Always control yourself :)',0
    db 'Its okay to take a break between problems.',0
    db 'Thanks for trying this kernel.',0
    db 0