CLEAR_REGION:
    push ax
	push bx
	push dx
	push cx
	push di
	
	xor di,di
	
	push ax
	movzx ax,al
	cmp ax, [resolutionModeX]
	jg .breaks
	pop ax

	push ax
    movzx ax,ah
	cmp ax, [resolutionModeX]
	jg .breaks
	pop ax
    
	push bx
	movzx bx,bl
	cmp bx, [NUMBERSCROLL]
	jg .breaks
	pop bx
	
	push bx
	movzx bx,bh
	cmp bx, [NUMBERSCROLL]
	jg .breaks
	pop bx
	
	
	xor dx,dx
	sub ah,al
	cmp ah, 0
	jle .breaks
	mov dl,ah
	mov ch, ah
	sub bh,bl
	cmp bh,0
	jle .breaks
	
	mov [temporary1],al
	mov [temporary2],ah
	
	xor ah,ah
	mov al,bl
	mov cl, [resolutionModeX]
	mul cl
	
	add ax, [temporary1]
	cmp word [IFGRAPHICS_MODE], 1
	
	je .jump
	shl ax,1
	
	.jump:
	xor dx,dx
	add dx,ax
	add di,dx
	
	mov al, [temporary2]
	xor ah,ah
	mov cx,ax
	mov [temporary2], ax
	SETAL_AH
	mov  word [temporary1], 0

	
	.loop:
	stosw
	add word [temporary1],2
	dec cx
	jnz .loop
	
	.loop2:
    sub di, [temporary1]
	add di, 160
	cmp bh,0
	je .breaks
	
	mov  word [temporary1], 0
	mov cx,[temporary2]
	dec bh
	jmp .loop
  
	
	.breaks:
	mov  word [temporary1], 0
	pop di
	pop cx
	pop dx
	pop bx
	pop ax
	ret


CLEARLINE:
	
    push ax
	push bx
    push cx
	push di
	push dx
	
	xor di,di
	mov [temporary1],ax
	mov bx, [resolutionModeX]
	mul bx
	mov bx,ax
	cmp word [IFGRAPHICS_MODE], 1
	je .jump
	shl bx, 1
	.jump:
	add di,bx
	
    mov cx, [resolutionModeX]
	
	mov al,0x0
	mov ah, [current_color]

	rep stosw
	mov ax, [temporary1]
	mov bx, [cursor_y]
	cmp ax,bx
	jne .breaks
	mov word [cursor_x], 0
	call CURSOR_GO
	
	.breaks:
	pop dx
	pop di
	pop cx
	pop bx
    pop ax
    ret
	

CHECKLINE:
	
    push ax
	push bx
    push cx
	push di
	push dx
	
	xor di,di
	mov bx, [resolutionModeX]
	mul bx
	mov bx,ax
	cmp word [IFGRAPHICS_MODE], 1
	je .jump
	shl bx, 1
	.jump:
	add di,bx
	
    mov cx, [resolutionModeX]
	
	.loop:
	mov bx, [es:di]
	cmp bl,0x20
	jne .change
	add di,2
	dec cx
	jnz .loop
	mov ax,0
	mov [TRUE_FALSE],ax
	jmp .breaks 
	
	
	
	.change:
	mov ax,1
	mov [TRUE_FALSE],ax
	
	.breaks:
	pop dx
	pop di
	pop cx 
	pop bx
    pop ax
    ret