%macro DEBUG_PRINT 0
       push bp
	   mov bp,sp

	   push [bp + 6]
	   push [bp + 4]
	   call strcat
	   push valcpy
	   call PRINT

	   pop bp

%endmacro


%macro WINDOW_OR_RECTANGLE 0
       
	   cmp byte [TRUE_FALSE_WINDOW], 1
	   jne %%jmp1
       call DRAW_WINDOW_FRAME
	   jmp %%breaks

	   %%jmp1:
	   call DRAWOUTLINE_RECTANGLE

	   %%breaks:
       
%endmacro


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
	push bx
	
	cmp word [shiftmode],1
	je %%shift
	
	cmp word [capslock], 1
	je %%shift
	
	mov al, [keyboard_map + bx]
	jmp %%jump
	
	%%shift:
	mov al, [shift_map + bx]
	
	%%jump:
    mov bx, word [string_length]
	mov [string_type + bx], al
	inc word [string_length]
    mov ah, [current_color]
    stosw

	pop bx
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


%macro INTRO 0
	mov word [cursor_x],0
	mov word [cursor_y],10
	mov word [cursor_x],0
	mov word [cursor_y],12
%endmacro

%macro SETCOLOR 1

mov word [current_color], %1
call CLEAR_SCREEN

%endmacro



%macro MASK_KEYBOARD 0

    push ax
    mov al, 0xFE
    out MASTER_READ_DATA, al
    pop ax

%endmacro

%macro UN_MASK_EVERYTHING 0

    push ax
    mov al, 0xFC
    out MASTER_READ_DATA, al
    pop ax

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