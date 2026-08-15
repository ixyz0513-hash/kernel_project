CURSOR_START_REG equ 0x0A
CURSOR_END_REG   equ 0x0B


CURSOR_POSITION_POP:
push ax
push dx
push bx
   
call CURSOR_POSITION
   
pop bx
pop dx
pop ax
ret


CURSOR_POSITION:
xor ax,ax
mov ax, [cursor_y]
mov bx, [resolutionModeX]
mul bx
add ax, [cursor_x]
mov bx,ax
	
mov [cursor_position], bx
IFGRAPHICS_MODE_SHIFT
ret


HIGHLIGHT_TEXT: ; dont use its bad
push ax
push bx
push di
	
call CURSOR_POSITION
	
mov di, [cursor_position]
	
mov al, [di]
cmp al, 0x0
je .breaks
cmp al, 0x20
je .breaks
	
add di,1
mov ah, [di]
or ah,192
and ah,207
mov [di], ah
    
.breaks:
pop di
pop bx
pop ax
ret
	


UNHIGHLIGHT_TEXT: ; dont use its bad
push ax
push bx
push di
	
call CURSOR_POSITION
	
	
mov al, [es:di]
cmp al, 0x0
je .breaks
cmp al, 0x20
je .breaks
	
mov di, [cursor_position]
add di,1
mov ah, [current_color]
mov [es:di], ah
    
.breaks:
pop di
pop bx
pop ax
ret




INCREMENTMOUSEXY:
push bp
mov bp,sp

push ax
push bx

cmp byte [IF_FROM_TEXTUP],1
je .jmp1
mov ax, [resolutionModeX]
dec ax
jmp .jmp2

.jmp1:
mov ax, [textup_border]

.jmp2:
movzx bx, byte [move_cursor_x_times]

add [cursor_x],bx
cmp word [cursor_x], ax
jg .incerY
jmp .breaks

.incerY:
cmp byte [IF_FROM_TEXTUP],1
jne .jmp3

add di,82
mov word [cursor_x],1

jmp .breaks

.jmp3:
call NEWLINE

.breaks:
pop bx
pop ax
pop bp

ret



DECREMENTMOUSEXY:
push ax

movzx ax, byte [move_cursor_x_times]
sub word [cursor_x],ax
jnc .breaks

.decY:
call NEWLINEUP

.breaks:
pop ax

ret




CURSOR_GO:

push dx
push ax
push bx

call CURSOR_POSITION

mov dx,CRTC_INDEX_PORT
mov al,0x0E
out dx,al


mov dx,CRTC_DATA_PORT
mov al,bh
out dx,al

mov dx,CRTC_INDEX_PORT
mov al,0x0F
out dx,al

mov dx,CRTC_DATA_PORT
mov al, bl
out dx,al

pop bx
pop ax
pop dx

ret



CHANGEUNDERLINE:
push ax
push dx
push bx
   
mov [temporary1], al
mov [temporary2], bl
mov dx, CRTC_INDEX_PORT
mov al, CURSOR_START_REG
out dx,al
mov dx, CRTC_DATA_PORT
mov al, [temporary1]
out dx,al
out dx,al
   
mov dx, CRTC_INDEX_PORT
mov al, CURSOR_END_REG
out dx,al
mov dx, CRTC_DATA_PORT
mov al, [temporary2]
out dx,al
    
pop bx
pop dx
pop ax
  
ret