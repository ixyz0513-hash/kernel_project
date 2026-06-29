
%macro CHANGECOLOR_IFTRUE 0

    cmp byte [CHANGECHARACTER], 1
	je %%changecharacter
	SETAL_AH
	jmp %%jump
	
	%%changecharacter:
	mov al, [CHARACTER_NUMBER]
	mov ah, [current_color]
	
	%%jump:

%endmacro



%macro TYPES 0
    push ax
	
	cmp word [shiftmode],1
	je %%shift
	
	cmp word [capslock], 1
	je %%shift
	
	mov al, [keyboard_map + bx]
	jmp %%jump
	
	%%shift:
	mov al, [shift_map + bx]
	
	%%jump:
    mov ah, [current_color]
    stosw
	
    pop ax
%endmacro




%macro IFGRAPHICS_MODE_SHIFT 0

    cmp word [IFGRAPHICS_MODE], 1
	je %%jump
	shl word [cursor_position], 1
	%%jump:
%endmacro


%macro CURSOR_POSITION 0
  
    xor ax,ax
	mov ax, [cursor_y]
    mov bx, [resolutionModeX]
    mul bx
    add ax, [cursor_x]
    mov bx,ax
	
    mov [cursor_position], bx
	IFGRAPHICS_MODE_SHIFT
%endmacro






%macro VERTRET_CHECK 0
    push dx
    push ax
    mov dx, FLIP_ATTRIBUTE

%%wait_end:
    in al, dx
    test al, 8
    jnz %%wait_end

%%wait_start:
    in al, dx
    test al, 8
    jz %%wait_start          

    pop ax
    pop dx
%endmacro


%macro SETAL_AH 0
	 mov al, 0x0
     mov ah, [temporary_color]
%endmacro


%macro SETAL_AH_CURRENT 0
	 mov al, 0x0
     mov ah, [current_color]
%endmacro



%macro CLEAR_SCREEN 0
      push ax
	  push bx
	  push cx
	  push di
	  
	  xor di,di
	  mov bx, [resolutionModeX]
	  mov ax, [NUMBERSCROLL]
	  mov [temporary1], ax
	  add word [temporary1], 1
	  mov ax, [temporary1]
	  mul bx
	  mov bx,ax
	  mov cx, bx
	  mov al, 0x0
	  mov ah, [current_color]
	  
	  rep stosw
	  
	  
	  pop di
	  pop cx
	  pop bx
	  pop ax
%endmacro

%macro INTRO 0
	mov word [cursor_x],0
	mov word [cursor_y],10
	push val4
    call PRINT
	mov word [cursor_x],0
	mov word [cursor_y],12
%endmacro

%macro SETCOLOR 1

mov word [current_color], %1
CLEAR_SCREEN

%endmacro





%macro CHECKIF_SCROLLDOWN 0
push ax

mov word [cursor_x],0
mov ax, [NUMBERSCROLL]
cmp [cursor_y], ax
jge %%scroll

mov word [TRUE_FALSE2], 0
inc word [cursor_y]
call CURSOR_GO

jmp %%breaks

%%scroll:

mov word [TRUE_FALSE2], 1
call SCROLLSCREENDOWN
inc word [cursor_y]

%%breaks:
pop ax
%endmacro




%macro CHECKIF_SCROLLUP 0
push ax
push bx

mov bx, [resolutionModeX]
dec bx

mov word [cursor_x],bx

dec word [cursor_y]
mov ax, [WHEN_SCROLLSCREENUP]
cmp [cursor_y], ax
jb %%scroll



jmp %%breaks

%%scroll:

inc word [cursor_y]
call SCROLLSCREENUP
dec word [cursor_y]

%%breaks:
call CURSOR_GO
pop bx
pop ax
%endmacro





%macro NEWLINE 0

CHECKIF_SCROLLDOWN
call CURSOR_GO

%endmacro