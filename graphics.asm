CLEAR_SCREEN:
      push ax
	  push bx
	  push cx
	  push di
	  
	  xor di,di
	  mov bx, [resolutionModeX]
	  mov ax, [NUMBERSCROLL]
	  mov [temporary1], ax
	  add word [temporary1], 7
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
	  ret




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
   
   pop dx
   pop ax
   ret

   
   
DRAW_WINDOW_FRAME:
   
   
   mov byte [CHANGECHARACTER],1
   
   call DRAWOUTLINE_RECTANGLE
   
   mov byte [CHANGECHARACTER],0
   
   ret


DRAWFILLED_WINDOWTEXT:
	push bp
	mov bp,sp
	push si
	push bx
	push cx
	push dx
	
	call DRAWFILLED_WINDOW ; parameters passed in
	
	
	mov [temporary1],cx
	sub cx,bx
	shr cx,1
	mov bx,[temporary1]
	sub bx,cx
	add ax,1
	mov si,[bp + 4]
	push word [current_color]
	mov dx,[shadow_color]
	mov [current_color],dx
	push si
	call PRINT_STRING_AT

	pop word [current_color]
	
	sub ax,1
	pop dx
	pop cx
	pop bx
	pop si
	pop bp
	ret
   
   
DRAWFILLED_WINDOW:
    push ax ; x1
	push bx ; y1
	push dx ; x2
	push cx ; y2
	; parameters passed in
    
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

	
	
	push word [temporary_color]

	mov cx, [shadow_color]
	mov [temporary_color], cx
	
	call CLEAR_REGION
    
    pop word [temporary_color]
	
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
	
	
	push word [cursor_y]
	push word [cursor_x]
	
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
	call CURSOR_POSITION
	
	mov di, [cursor_position]
	CHANGECOLOR_IFTRUE
	
	rep stosw
	
	.breaks:
	pop word [cursor_x]
	pop word [cursor_y]
	
	
	pop dx
	pop cx
	pop bx
	pop di
	pop ax
    ret
	

DRAWVERTICALLINE: ; the variant code is bad i would suggest not to use it
    push ax
	push bx
	push cx
	push dx
	push di
	
	push word [cursor_y]
	push word [cursor_x]
	
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
	call CURSOR_POSITION
	
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
	pop word [cursor_x]
	pop word [cursor_y]
	
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
   
   ; below draw the face
	
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
   
   
   
   push word [cursor_y]
   push word [cursor_x]
   
   mov word [cursor_x], 0
   mov word [cursor_y], 0
   
   add [cursor_x], ax
   add [cursor_y], bx
   
   call CURSOR_POSITION
   
   mov di, [cursor_position]
   
   SETAL_AH
   
   stosw
   
   pop word [cursor_x]
   pop word [cursor_y]
   
   pop cx
   pop di
   pop bx
   pop ax
   
   ret