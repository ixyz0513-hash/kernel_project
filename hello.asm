[bits 16]
[org 0x7c00]


start:
    cli
    xor ax,ax
	mov ds,ax
	mov es, ax
	mov sp, 0x7c00
	sti
	xor ax, ax
	mov bx, 0x7E00
	mov ah, 0x2
	mov al, 17
	mov ch, 0x0
	mov cl, 0x2
	mov dh, 0x0
	int 0x13
	jc Errors
	jmp 0x0000:0x7E00
	
	
Errors:
  mov ah,0x0E
  mov al, '!'
  int 0x10
  cli
  hlt


	
times 510 - ($ - $$) db 0

dw 0xAA55



%include "macros.asm"




sector2:
   cld
   cli
   xor ax,ax
   mov ds,ax
   mov ax,0x9000
   mov ss,ax
   mov ax, 0xB800
   mov es,ax
   mov sp, 0x1000
   xor ax,ax
   xor bx,bx
   xor cx,cx
   xor dx,dx
   xor di,di
   xor si,si
   sti
   call DISABLE_KEYBOARD
   VERTRET_CHECK
   call PIT_SETUP
   call START_UP_PIC
   call VECTOR_TABLE_SETUP
   call SELECT_CHANNEL_0
   
   
   CLEAR_SCREEN
   call SCROLLDOWN
   call SPLIT_SCREEN
   
   VERTRET_CHECK
   call DISABLE_MOUSE
   
   call NEWLINE
   VERTRET_CHECK
   
   call CHECK_KEYBOARD
   VERTRET_CHECK
   
   
   
   mov al, 1
   mov bl, 12
   call CHANGEUNDERLINE

   INTRO
   call CURSOR_GO

   call NEWLINECLI

   mov ax,50
   mov dx,60
   mov bx, 10
   mov cx, 15
   call DRAWFILLED_WINDOW
   
   call ENABLE_KEYBOARD
   VERTRET_CHECK

   call STOP_SOUND
   call SELECT_CHANNEL_2
   
   
   sti
   .finish:
   hlt
   jmp .finish



   
%include "str.asm"

%include "graphics.asm"

%include "scrolling.asm"

%include "lines.asm"

%include "printing.asm"

%include "cursorunderline.asm"

%include "seqfunc.asm"

%include "cli.asm"

%include "ps2.asm"

%include "pic.asm"

%include "pit.asm"

%include "newline.asm"

%include "variables.asm"
	
	
times 9216 - ($-$$) db 0