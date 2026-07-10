DRAW_SHADOW:
    push ax
	push bx
	push dx
	push cx
    
	mov [temporary1], ax
	
	
	mov ax, [temporary_color]
	mov [temporary2], ax
	
	mov ax, [shadow_color]
	mov [temporary_color],ax
	
	mov ax,[temporary1]
	call DRAWHORIZONTALLINE
	mov dx,cx
	call DRAWVERTICALLINE
	
	
	mov ax, [temporary2]
	mov [temporary_color], ax
    
	pop cx
	pop dx
	pop bx
    pop ax
    ret





ENABLE16_COLORSBACKGROUND:
     push dx
	 push ax
	 
	 cli
     
	 mov dx, FLIP_ATTRIBUTE
	 in al, dx
	 xor al,al
	 
	 mov dx, ATTRIBUTE_DATA_INDEX
	 mov al,0x10
	 out dx,al
	 
	 mov dx, ATTRIBUTE_READ
	 in al,dx
	 and al, 247
	 
	 mov dx, ATTRIBUTE_DATA_INDEX
	 out dx,al
	 
	 mov al, 0x20
     out dx, al
	 
	 sti
	 
     pop ax
	 pop dx
     ret




SPLIT_SCREEN:
   push ax
   push dx
   
   
   mov dx, CRTC_INDEX_PORT
   mov ax, 0x2F18
   out dx,ax
   
   mov dx, CRTC_INDEX_PORT
   mov al, 0x7
   out dx,al
   
   mov dx, CRTC_DATA_PORT
   in al,dx
   or al,16
   out dx,al
   
   mov dx, CRTC_INDEX_PORT
   mov al, 0x9
   out dx,al
   
   mov dx, CRTC_DATA_PORT
   in al,dx
   and al,191
   out dx,al
   
   mov bx,0
   xor ax,ax
   push message
   call PRINT_STRING_AT
   
   pop dx
   pop ax
   ret

   
   
DRAW_WINDOW_FRAME:
   
   
   mov byte [CHANGECHARACTER],1
   
   call DRAWOUTLINE_RECTANGLE
   
   mov byte [CHANGECHARACTER],0
   
   ret
   
   
   
DRAWFILLED_WINDOW:
    push ax ; x1
	push bx ; y1
	push dx ; x2
	push cx ; y2

    
	WINDOW_OR_RECTANGLE
	
	push ax
	push bx
	push dx
	push cx 
	
	cmp byte [TRUE_FALSE_WINDOW], 1
	je .jmp

	add bl,1
	sub cl,1
	add al,1
	add dl,1
	
	.jmp:
	mov ah,dl
	mov bh,cl
	
	mov cx, [temporary_color]
	
	mov [temporary1], cx
	add word [temporary_color],0x10
	
	call CLEAR_REGION
    
    mov cx, [temporary1]
	mov [temporary_color], cx
	
	pop cx
    pop dx
	pop bx
	pop ax
	
   	WINDOW_OR_RECTANGLE
   
    .breaks:
	pop cx
    pop dx
	pop bx
	pop ax
    ret 
   
 
 
DRAWOUTLINE_RECTANGLE:
    push ax ; x1
	push bx ; y1
	push dx ; x2
	push cx ; y2
	
	cmp ax, [resolutionModeX]
	jg .breaks
	cmp bx, [NUMBERSCROLL]
	jg .breaks
	cmp dx, [resolutionModeX]
	jg .breaks
	cmp cx, [NUMBERSCROLL]
	jg .breaks

	mov [slowTemporary1], dx
	call DRAWHORIZONTALLINE
	mov [temporary4], bx
    
	mov dx,cx
	sub dx, bx
	add bx, dx
	mov dx, [slowTemporary1]


	call DRAWHORIZONTALLINE
    
	mov dx, cx
	mov bx, [temporary4]
	call DRAWVERTICALLINE
	
	mov [temporary1],cx
	mov bx, [temporary4]
	sub [slowTemporary1], ax
	
	cmp word [slowTemporary1],0
	jle .breaks
	cmp dx,[resolutionModeX]
	jg .breaks
	
	add ax,[slowTemporary1]
	mov dx, [temporary1]
	mov byte [IFRIGHT_CORNER], 1
	cmp byte [CHANGECHARACTER], 1
	je .jmp2
    add dx,1

    .jmp2:
	call DRAWVERTICALLINE
	
    mov byte [IFRIGHT_CORNER],0
    .breaks:
	pop cx
    pop dx
	pop bx
	pop ax
    ret 


   
DRAWHORIZONTALLINE:
    push ax
	push di
	push bx
	push cx
	push dx
	
	
	mov cx,[cursor_y]
	mov [temporary2], cx
	
	mov cx,[cursor_x]
	mov [temporary3], cx
	
	mov word [cursor_x], 0
    mov word [cursor_y], 0
   
    add [cursor_x], ax
    add [cursor_y], bx
	
    sub dx,ax
	cmp dx,0
	jle .breaks
	cmp dx,[resolutionModeX]
	jg .breaks
	mov cx, dx
	CURSOR_POSITION
	
	mov di, [cursor_position]
	CHANGECOLOR_IFTRUE
	
	rep stosw
	
	.breaks:
	
	mov cx,[temporary2]
	mov [cursor_y], cx
	
	mov cx,[temporary3]
	mov [cursor_x], cx
	
	
	pop dx
	pop cx
	pop bx
	pop di
	pop ax
    ret
	

DRAWVERTICALLINE:
    push ax
	push bx
	push cx
	push dx
	push di
	
	mov cx,[cursor_y]
	mov [temporary2], cx
	
	mov cx,[cursor_x]
	mov [temporary3], cx
	
	mov word [cursor_x], 0
    mov word [cursor_y], 0
   
    add [cursor_x], ax
    add [cursor_y], bx
	
	
    sub dx,bx
	cmp dx,0
	jle .breaks
	cmp dx,[NUMBERSCROLL]
	jg .breaks
	mov cx, dx
	CURSOR_POSITION
	
	mov di, [cursor_position]
	mov al, [CHARACTER_NUMBER2]
	mov [CHARACTER_NUMBER],al
	
    cmp byte [CHANGECHARACTER], 0
	je .jmp
	
	mov ah, [current_color]
	
	cmp byte [IFRIGHT_CORNER], 1
	je .right
	mov al, 218
	jmp .jmp2
    
    .right:
    mov al, 191 	
	
	.jmp2:
	stosw
	add di,158
	dec cx
	
	.jmp:
	CHANGECOLOR_IFTRUE
	
	.loop:
	cmp cx,0
	jle .breaks
	stosw
	dec cx
	add di,158
    jmp .loop

	
		
	
	
	.breaks:

    cmp byte [CHANGECHARACTER], 0
	je .jmp4
	
	cmp byte [IFRIGHT_CORNER], 1
	je .right2
	mov al, 192
	jmp .jmp3
    
    .right2:
    mov al, 217

    
    .jmp3:
    stosw

    .jmp4:
	mov cx,[temporary2]
	mov [cursor_y], cx
	
	mov cx,[temporary3]
	mov [cursor_x], cx
	
	mov byte [CHARACTER_NUMBER],196
	
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
    ret
	




DRAWSMILE:
   push ax
   push bx
   push cx
   
   call SETPIXEL ; draw eye
   
   add ax, 2
   call SETPIXEL ; draw eye
   
   
   xor cx,cx
   
   sub ax, 3
   add bx, 2
   
   .loop:
   call SETPIXEL
   
   cmp cx,2
   je .loop2
   
   inc ax
   inc bx
   inc cx
   jmp .loop
   
   .loop2:
   
   cmp cx,5
   je .breaks
   
   call SETPIXEL
   inc cx
   inc ax
   dec bx
   jmp .loop2
   
   ; below draw the face
   
   .breaks:
   
   pop cx
   pop bx
   pop ax
   
   ret



SETPIXEL:
   push ax
   push bx
   push di
   push cx
   
   
   
   mov cx, [cursor_x]
   mov [temporary1], cx
   
   mov cx, [cursor_y]
   mov [temporary2], cx
   
   mov word [cursor_x], 0
   mov word [cursor_y], 0
   
   add [cursor_x], ax
   add [cursor_y], bx
   
   CURSOR_POSITION
   
   mov di, [cursor_position]
   
   SETAL_AH
   
   stosw
   
   mov cx, [temporary1]
   mov [cursor_x],cx
   
   mov cx, [temporary2]
   mov [cursor_y],cx
   
   pop cx
   pop di
   pop bx
   pop ax
   
   ret