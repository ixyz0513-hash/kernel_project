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
   
   CLEAR_SCREEN
   call SCROLLDOWN
   call SPLIT_SCREEN
   
   VERTRET_CHECK
   call DISABLE_MOUSE
   
   NEWLINE
   VERTRET_CHECK
   call DISABLE_KEYBOARD
   VERTRET_CHECK
   call CHECK_KEYBOARD
   VERTRET_CHECK
   call ENABLE_KEYBOARD
   VERTRET_CHECK
   call CHECK_KEYBOARD_INTERFACE
   
   
   mov al, 1
   mov bl, 12
   call CHANGEUNDERLINE
   
   push val2
   push val3
   call strcat
   
   
   INTRO
   push valcpy
   call PRINT
   NEWLINE
   push valcpy
   call TURNUPPER_CASE
   push valcpy
   call PRINT
   NEWLINE
   
   push valcpy
   call TURNLOWER_CASE
   push valcpy
   call PRINT
   NEWLINE
   push valcpy
   call strlen
   push word [lengthstring]
   call itoa
   push bufferstring
   call PRINT
   
   mov word [temporary_color], 0x8A
   
   call ENABLE16_COLORSBACKGROUND
   
   mov ax,60
   mov dx,79
   mov bx,0
   mov cx,6
   call DRAWFILLED_RECTANGLE
   
   mov ax, 70
   mov bx, 1
   
   call DRAWSMILE
   
   mov ax,50
   mov dx,79
   mov bx,11
   mov cx,18
   
   call DRAW_WINDOW_FRAME
   
   .loop:
   call TYPE_KEYBOARD
   jmp .loop
     
   
   finish:
   cli
   hlt



   
%include "str.asm"

%include "graphics.asm"

%include "scrolling.asm"

%include "lines.asm"

%include "printing.asm"

%include "cursorunderline.asm"

%include "seqfunc.asm"

%include "ps2.asm"


val2 db 'Hello',0
val3 db ' world.',0
val4 db 'pOSPOSOIFETERJITEJIWUGTJIEWJI',0
message db 'HI OMG HI THIS IS TESTING LINE COMPARE OK OK',0

debugval_good db 'Good',0
debugval_bad db 'Bad',0

debughigh db 'high',0
debuglow db 'low',0
debugdata db 'data',0  
debugclock db 'clock',0

valcpy db '                                                                                                             ',0 ; used in strcat to combine two variables into one
bufferstring db 0,0,0,0,0,0,0,0 ; used in itoa function to store  number chars
lengthstring dw 0 ; used in strlen function to store the length of the string

cursor_y dw 4
cursor_x dw 0
cursor_position dw 0 ; used to determine the position of the underline cursor

current_color dw 0x7E ; used in clearscreen macro
temporary_color dw 0 ; color used in functions like filled rectangle just drawing stuff in general that is not involved with the clear screen macro
shadow_color dw 0x80 ; used in the draw shadow function

temporary1 dw 0 ; used in storing temporary values
temporary2 dw 0 ; used in storing temporary values
temporary3 dw 0 ; used in storing temporary values
temporary4 dw 0 ; used in storing temporary values
slowTemporary1 dw 0 ; only use in nested functions
slowTemporary2 dw 0 ; only use in nested functions

resolutionModeX dw 80
resolutionModeY dw 25

HOWMUCHSCROLL dw 0 ; in scrollscreendown you add 80 to it to scroll down one row because the text mode has 80 collumns and after that another row in scrollscreenup it compares it by 0 if it already did scrollscreendown if not it goes to the break label otherwise it substracts it by 80 
NUMBERSCROLL dw 18 ; a number for printing and newline macro when to scrolldown when you scroll down it increments it scroll screen up then decrements it
WHEN_SCROLLSCREENUP dw 0

TRUE_FALSE db 0 ; just a bool
TRUE_FALSE2 db 0 ; just a bool
IFRIGHT_CORNER db 0
TRUE_FALSE_STRCMP db 0 ; just a bool used in strcmp


CHANGECHARACTER db 0 ; a bool if 0 dont change the al if 1 change it
CHARACTER_NUMBER db 196 ; ascii
CHARACTER_NUMBER2 db 179 ; ascii

IFGRAPHICS_MODE db 0 ; checks if graphics mode


shiftmode db 0 ; checks if user is holding shift
capslock db 0 ; check if user touched capslock


; below data ports and index ones
CRTC_INDEX_PORT equ 0x3D4
CRTC_DATA_PORT  equ 0x3D5

SEQ_INDEX_PORT  equ 0x3C4
SEQ_DATA_PORT   equ 0x3C5

ATTRIBUTE_DATA_INDEX equ 0x3C0
ATTRIBUTE_READ equ 0x3C1
FLIP_ATTRIBUTE equ 0x3DA


CURSOR_START_REG equ 0x0A
CURSOR_END_REG   equ 0x0B
ADDRESS_HIGH_START equ 0x0C
ADDRESS_LOW_START equ 0x0D

CONTROL_STATUS_REGISTER equ 0x64
DATA_PORT equ 0x60


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
    db 'B', 'N', 'M', '<', '>', '?', 0, '*', 0, ' ', 0, 0, 0, 0, 0, 0
    
    ; 0x40 - 0x4F
    db 0, 0, 0, 0, 0, 0, 0, '7', 0, '9', '-', 0, '5', 0, '+', '1'
    
    ; 0x50 - 0x56
    db 0, '3', '0', '.', 0, 0, '\'
	
	
times 9216 - ($-$$) db 0