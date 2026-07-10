PRINT_STRING_CENTER:
    push bp
	mov bp,sp
	
	push ax
	push bx
	push si
	push di
	
	mov si,[bp + 4]
    push si
	call strlen
	mov ax,[resolutionModeX]
	shr ax,1
	mov bx,[lengthstring]
	shr bx,1
	sub ax,bx
	cmp ax,0
	jl .breaks
	
	mov bx, [NUMBERSCROLL]
	shr bx,1
	push si
	call PRINT_STRING_AT
	
	
	.breaks:
	pop di
	pop si
    pop bx
	pop ax
	pop bp
    ret 2




PRINT_STRING_AT:
     push bp
	 mov bp,sp
	 
     push ax
	 push bx
	 push di
	 push dx
	 push si
	 
	 xor di,di
     
	 cmp ax, [resolutionModeX]
	 jg .breaks
	 cmp bx, [NUMBERSCROLL]
	 jg .breaks
	 
	 mov [temporary1], ax
	 
	 mov ax, bx
	 mov bx, [resolutionModeX]
	 mul bx
	 add ax, [temporary1]
	 
	 cmp word [IFGRAPHICS_MODE], 1
	 je .jump
	 shl ax, 1
	 .jump:
	 
      add di,ax
	  mov si, [bp + 4]
	  SETAL_AH_CURRENT
	  
	  .loop:
	  lodsb
	  test al,al
	  jz .breaks
	  stosw
	  jmp .loop
     
	 .breaks:
	 pop si
	 pop dx
	 pop di
	 pop bx
	 pop ax
	 pop bp
	 ret 2


PRINT:
    push bp
	mov bp,sp
	
    push ax
	push si
	push di
	push bx
	
	CURSOR_POSITION
	mov al,0x0
	mov ah, [current_color]
	mov di, [cursor_position]
    mov si, [bp + 4]
	
	
   .loop:
	lodsb
	test al, al
	jz .breaks
	stosw
	call INCREMENTMOUSEXY
	
	jmp .loop
	
    .breaks:
	call CURSOR_GO
	pop bx
	pop di
	pop si
	pop ax
	pop bp
	
	
	
	
	ret 2
	



itoa:
     push bp
     mov bp, sp 
	 
     pusha
	 
     xor si,si
     mov ax, [bp + 4]
     xor cx, cx
     mov bx, 10
 
     cmp ax, 0x0
     jge .multipleDigits

     .negs:
     mov byte [bufferstring],'-'
     inc si
     neg ax
 
     .multipleDigits:
     xor dx,dx
     div bx
     add dx,0x30
     push dx
     inc cx
     test ax,ax
     jnz .multipleDigits
  
     .pops:
     pop dx
     mov [bufferstring + si], dl
     inc si
     dec cx
     jnz .pops

     mov byte [bufferstring + si], 0
     popa
     pop bp
     ret 2