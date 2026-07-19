global KEYBOARD_HANDLER

KEYBOARD_HANDLER:
   push ax
   push bx
   push di
   
   xor bx,bx
   xor ax,ax
   xor di,di
   
   in al,DATA_PORT
   test al,0x80
   jnz .release
   
   .print:
   xor bx,bx
   
   call CURSOR_POSITION_POP
   
   mov di, [cursor_position]
   movsx bx,al

   cmp al,0x3A
   je .caps
   
   cmp al,0x0E
   je .back_slash
   
   cmp al,0x1C
   je .enter
   
   cmp al,0x2A
   je .shift
   
   cmp al,0x36
   je .shift

   cmp al,0x48
   je .uparrow
   
   jmp .jump
   
   
   .back_slash:
   call BACK_SLASH
   
   jmp .jump2
   
   .enter:
   call ENTERS
   jmp .breaks

   .uparrow:
   call UPARROW
   jmp .breaks
   
   .shift:
   mov word [shiftmode], 1
   
   jmp .breaks
   
   .caps:
   cmp word [capslock],0
   je .turn
   jmp .false
   
   .turn:
   mov word [capslock], 1
   jmp .breaks
   
   .false:
   mov word [capslock], 0
   jmp .breaks

   
   .jump:
   TYPES
   .jump2:
   call INCREMENTMOUSEXY
   call CURSOR_GO
   xor di,di
   jmp .breaks
   
   
   .release:
   
   cmp al, 0xAA
   je .shiftbreak
   
   cmp al, 0xB6
   je .shiftbreak
   
   jmp .breaks
   
   .shiftbreak:
   mov word [shiftmode], 0
   
   
   .breaks:
   xor ax,ax

   mov al,0x20
   out MASTER_DATA, al

   pop di
   pop bx
   pop ax
   iret
   
   
   
   
BACK_SLASH:
   MASK_KEYBOARD
   push ax
   push di
   push bx

   cmp byte [string_length],0
   jne .jmp

   call DECREMENTMOUSEXY
   mov al, 0XFF
   mov bl, 0xFF
   mov cx, 10
   call BEEP

   mov ax,50
   call WAIT_TICKS

   jmp .breaks
   
   .jmp:
	call DECREMENTMOUSEXY
	call CURSOR_POSITION_POP

	mov di, [cursor_position]
	mov ah, [current_color]
   mov al, 0x0
   stosw

   mov bx, word [string_length]
   mov byte [string_type + bx], 0x0
   dec byte [string_length]

   

	call DECREMENTMOUSEXY
   
   .breaks:
   pop bx
   pop di
   pop ax
   UN_MASK_EVERYTHING
	ret   
   
   
ENTERS:
   push bx
   mov bx, word [string_length]
   mov byte [string_type + bx], 0x0
   
   
   push string_type
   call CLI

   mov word [string_length], 0x0
   
   pop bx
   ret
   

UPARROW:
   
   ;NEWLINEUP dont comment it out since its you will be always in the cli
   
   .breaks:
   ret
   
DISABLE_MOUSE:
   push ax
   
   in al, DATA_PORT
   xor al,al
   
   mov al, 0xA7
   out CONTROL_STATUS_REGISTER, al
   
   pop ax
   ret
   
   

ENABLE_MOUSE:
   push ax
   
   in al, DATA_PORT
   xor al,al
  
   mov al, 0xA8
   out CONTROL_STATUS_REGISTER, al
   
   pop ax
   ret
   
   
   
DISABLE_KEYBOARD:
   push ax
   
   in al, DATA_PORT
   xor al,al

   mov al, 0xAD
   out CONTROL_STATUS_REGISTER, al
   
   pop ax
   ret
   
   
   
   
ENABLE_KEYBOARD:
   push ax
   
   in al, DATA_PORT
   xor al,al

   mov al, 0xAE
   out CONTROL_STATUS_REGISTER, al
   
   pop ax
   ret
   
   
CHECK_KEYBOARD:
   push ax
   
   in al, DATA_PORT
   xor al,al
   


   mov al, 0xAA
   out CONTROL_STATUS_REGISTER, al
   in al, DATA_PORT
   cmp al, 0x55
   jnz .BAD
   
   .GOOD:
   push debugval_good
   call PRINT
   jmp .breaks
   
   .BAD:
   push debugval_bad
   call PRINT
   
   .breaks:
   pop ax
   ret
   
   
   
   
   
CHECK_KEYBOARD_INTERFACE:
   push ax
   
   in al, DATA_PORT
   xor al,al
   
   
   mov al, 0xAB
   out CONTROL_STATUS_REGISTER, al
   in al, DATA_PORT
   
   cmp al, 0x1
   jz .lowclock
   
   cmp al, 0x2
   jz .highclock
   
   cmp al, 0x3
   jz .lowdata
   
   cmp al, 0x4
   jz .highdata
   
   jmp .breaks
   
   .lowclock:
   push debugclock
   push debuglow
   DEBUG_PRINT
   jmp .breaks
   
   .highclock:
   push debugclock
   push debughigh
   DEBUG_PRINT
   jmp .breaks
   
   .lowdata:
   push debugdata
   push debuglow
   DEBUG_PRINT
   jmp .breaks
   
   .highdata:
   push debugdata
   push debughigh
   DEBUG_PRINT
   jmp .breaks
   
   .breaks:
   pop ax
   ret
   
