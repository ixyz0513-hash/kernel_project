
CURSOR_POSITION_POP:
   push ax
   push dx
   push bx
   
   CURSOR_POSITION
   
   pop bx
   pop dx
   pop ax
   ret


HIGHLIGHT_TEXT:
    push ax
	push bx
	push di
	
	CURSOR_POSITION
	
	mov di, [cursor_position]
	
	mov al, [es:di]
	cmp al, 0x0
	je .breaks
	cmp al, 0x20
	je .breaks
	
	add di,1
	mov ah, [es:di]
	or ah,192
	and ah,207
	mov [es:di], ah
    
	.breaks:
	pop di
    pop bx
	pop ax
	ret
	


UNHIGHLIGHT_TEXT:
    push ax
	push bx
	push di
	
	CURSOR_POSITION
	
	
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
push ax

mov ax, [resolutionModeX]
dec ax

inc word [cursor_x]
cmp word [cursor_x], ax
jg .incerY
jmp .breaks

.incerY:
CHECKIF_SCROLLDOWN

.breaks:
pop ax

ret



DECREMENTMOUSEXY:
push ax

sub word [cursor_x],1
jnc .breaks

.decY:
CHECKIF_SCROLLUP

.breaks:
pop ax

ret




CURSOR_GO:

push dx
push ax
push bx

CURSOR_POSITION

mov dx,0x3D4
mov al,0x0E
out dx,al


mov dx,0x3D5
mov al,bh
out dx,al

mov dx,0x3D4
mov al,0x0F
out dx,al

mov dx,0x3D5
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