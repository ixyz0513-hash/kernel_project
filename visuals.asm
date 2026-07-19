DISPLAY_TIME:
   push ax
   push dx
   push bx
   push cx



   mov ax,50
   mov dx,79
   mov bx,10
   mov cx,14
   call DRAWFILLED_WINDOW

   mov ax, [current_color]
   mov [slowTemporary1],ax
   mov ax, [shadow_color]
   mov [current_color],ax

   mov ax, 51
   mov bx, 12
   push system_seconds_str
   call PRINT_STRING_AT

   
   push word [SYSTEM_SECONDS]
   call itoa

   mov ax,67 ; HAHAHAHAH SO FUNNY :( 
   mov bx,12
   push bufferstring
   call PRINT_STRING_AT

   mov ax,[slowTemporary1]
   mov [current_color],ax
   
   pop cx
   pop bx
   pop dx
   pop ax
   ret