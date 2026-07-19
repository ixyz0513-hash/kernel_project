strlen:
	push bp
    mov bp,sp

	pusha
	
    xor cx,cx
    mov si,[bp + 4]
    
	.loop:
	lodsb
	test al,al
	jz .breaks
    inc cx
	jmp .loop
		
	.breaks:
	mov [lengthstring],cx

	popa
	pop bp

	ret 2




strcpy:
push bp
    mov bp,sp
pusha
    xor cx,cx
    mov si,[bp + 4]
    
	.loop:
	lodsb
	test al,al
	mov bx,cx
	jz .breaks
	mov [valcpy + bx],al
	inc cx
	jmp .loop
	
	.breaks:
mov byte [valcpy + bx],0
popa
pop bp

ret 2




strcat:
push bp
    mov bp,sp
pusha
    xor cx,cx
    mov si,[bp + 6]
    
	.loop:
	lodsb
	test al,al
	mov bx,cx
	jz .change
	mov [valcpy + bx], al
	inc cx
	jmp .loop
	
	.change:
	mov si,[bp + 4]
	
	.loop2:
	lodsb
	test al,al
	mov bx,cx
	jz .breaks
	mov [valcpy + bx], al
	inc cx
	jmp .loop2
	
	.breaks:
mov byte [valcpy + bx],0
popa
pop bp

ret 4


strcmp:
	push bp
	mov bp,sp

	push ax
	push bx
	push cx
	push dx
	push si
	push di
    
	mov byte [TRUE_FALSE_STRCMP], 0
    xor ax,ax
	xor bx,bx

	mov si, [bp + 6]
	mov di, [bp + 4]

	.loop:
    mov al, [si]
	mov bl, [di]


	cmp al,0x0
	je .success

	cmp al,bl
    jne .breaks
    
	inc si
	inc di
	jmp .loop

	.success:
	mov byte [TRUE_FALSE_STRCMP], 1
    
	.breaks:
	pop di
	pop si
    pop dx
	pop cx
	pop bx
	pop ax
	pop bp

	ret 4

    


TURNUPPER_CASE: 
      push bp
	  mov bp,sp
	  pusha
	  mov si, [bp + 4]
	  
      .loop:
	  lodsb
	  test al,al
	  jz .breaks
	  cmp al,'a'
	  jnae .loop
	  cmp al,'z'
	  jnbe .loop
	  sub al, 32
	  mov [si - 1], al
	  jmp .loop
	  
	  .breaks:
      popa
	  pop bp
      ret 2
	  
	  
	  
	  
TURNLOWER_CASE: 
      push bp
	  mov bp,sp
	  pusha
	  mov si, [bp + 4]
	  
      .loop:
	  lodsb
	  test al,al
	  jz .breaks

	  cmp al,'A'
	  jnae .loop
	  cmp al,'Z'
	  jnbe .loop
	  add al, 32
	  mov [si - 1], al
	  jmp .loop
	  
	  .breaks:
      popa
	  pop bp
      ret 2