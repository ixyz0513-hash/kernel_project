CAPS_LOCK equ 0x3A
BACK_SLASHs equ 0x0E
ENTERs equ 0x1C
SHIFT_LEFT equ 0x2A
SHIFT_RIGHT equ 0x36
UP_ARROW equ 0x48

shiftmode db 0 ; checks if user is holding shift
capslock db 0 ; check if user touched capslock


KEYBOARD_HANDLER:
   cli
   push ax
   push bx
   push di
   pushf
   
   xor bx,bx
   xor ax,ax
   xor di,di

   in al,CONTROL_STATUS_REGISTER
   test al,0x20
   jnz .clear
   jmp .jmp

   .clear:
   call POLL_DATA_PORT
   call POLL_DATA_PORT
   call POLL_DATA_PORT
   jmp .breaks

   .jmp:
   in al,DATA_PORT
   test al,0x80
   jnz .release
   
   .print:
   xor bx,bx
   
   call CURSOR_POSITION_POP
   
   mov di, [cursor_position]
   movsx bx,al

   cmp al,CAPS_LOCK
   je .caps
   
   cmp al,BACK_SLASHs
   je .back_slash
   
   cmp al,ENTERs
   je .enter
   
   cmp al,SHIFT_LEFT
   je .shift
   
   cmp al,SHIFT_RIGHT
   je .shift

   cmp al,UP_ARROW
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
   popf
   sti
   iret
   
   
   
   
BACK_SLASH:
   MASK_KEYBOARD
   push ax
   push di
   push bx

   cmp byte [string_length],0
   jne .jmp
   call DECREMENTMOUSEXY
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
   
   ;call NEWLINEUP dont comment it out since you will be always in the cli
   
   .breaks:
   ret



CHECK_OUTPUT_BUFFER:
   in al,CONTROL_STATUS_REGISTER
   and al,1
   jnz .breaks
   in al,DATA_PORT
   

   .breaks:
   ret
   
   
   
DISABLE_KEYBOARD:
   push ax
   
   call CHECK_OUTPUT_BUFFER

   mov al, 0xAD
   out CONTROL_STATUS_REGISTER, al
   
   pop ax
   ret
   
   
   
   
ENABLE_KEYBOARD:
   push ax
   
   call CHECK_OUTPUT_BUFFER

   mov al, 0xAE
   out CONTROL_STATUS_REGISTER, al
   
   pop ax
   ret
   
   
CHECK_CONTROLER:
   cli
   push ax

   call CHECK_OUTPUT_BUFFER

   mov al, 0xAA
   out CONTROL_STATUS_REGISTER, al
   call POLL_DATA_PORT
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
   sti
   ret
   
   
   
   
   
CHECK_KEYBOARD_INTERFACE:
   push ax
   
   call CHECK_OUTPUT_BUFFER
   
   
   mov al, 0xAB
   out CONTROL_STATUS_REGISTER, al
   call POLL_DATA_PORT
   
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
   


keyboard_map:
    ; 0x00 - 0x0F
    db 0, 0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 0, 0
    
    ; 0x10 - 0x1F
    db 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 0, 0, 'a', 's'
    
    ; 0x20 - 0x2F
    db 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', "'", '`', 0, '\', 'z', 'x', 'c', 'v'
    
    ; 0x30 - 0x3F
    db 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' ', 0, 0, 0, 0, 0, 0
    
    ; 0x40 - 0x4F
    db 0, 0, 0, 0, 0, 0, 0, '7', 0, '9', '-', 0, '5', 0, '+', '1'
    
    ; 0x50 - 0x56
    db 0, '3', '0', '.', 0, 0, '\'
	


shift_map:
    ; 0x00 - 0x0F
    db 0, 0, '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', 0, 0
    
    ; 0x10 - 0x1F
    db 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', 0, 0, 'A', 'S'
    
    ; 0x20 - 0x2F
    db 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', '"', '~', 0, '|', 'Z', 'X', 'C', 'V'
    
    ; 0x30 - 0x3F
    db 'B', 'N', 'M', '<', '>', '?', 0, '*', 0, 0x20, 0, 0, 0, 0, 0, 0
    
    ; 0x40 - 0x4F
    db 0, 0, 0, 0, 0, 0, 0, '7', 0, '9', '-', 0, '5', 0, '+', '1'
    
    ; 0x50 - 0x56
    db 0, '3', '0', '.', 0,0, '\'