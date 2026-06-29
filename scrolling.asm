

SCROLLDOWN:
    cli
    push cx
	mov cx,10
    .loop:
	call SCROLLSCREENDOWN
	dec cx
	jnz .loop
    
    pop cx
	sti
    ret




SCROLLSCREENUP:
    cli
    push ax
	push bx
	push dx
	
	
	
	cmp word [HOWMUCHSCROLL], 0
	je .breaks
	
	mov ax, [resolutionModeX]
	sub word [HOWMUCHSCROLL], ax
	xor ax,ax
	mov bx,[HOWMUCHSCROLL]
	
	mov dx,CRTC_INDEX_PORT
    mov al, ADDRESS_HIGH_START
    out dx,al
    mov dx, CRTC_DATA_PORT
    mov al,bh
    out dx,al
   
   
    mov dx,CRTC_INDEX_PORT
    mov al, ADDRESS_LOW_START
    out dx,al
    mov dx, CRTC_DATA_PORT
    mov al,bl
    out dx,al
	
	dec word [NUMBERSCROLL]
	dec word [WHEN_SCROLLSCREENUP]
	
	
	
	.breaks:
	pop dx
	pop bx
	pop ax
	sti
	ret
	
	
	
SCROLLSCREENDOWN:
    push ax
	push bx
	push dx
	
	mov ax, [resolutionModeX]
	add word [HOWMUCHSCROLL], ax
	xor ax,ax
	mov bx,[HOWMUCHSCROLL]
	
	mov dx,CRTC_INDEX_PORT
    mov al, ADDRESS_HIGH_START
    out dx,al
    mov dx, CRTC_DATA_PORT
    mov al,bh
    out dx,al
   
   
    mov dx,CRTC_INDEX_PORT
    mov al, ADDRESS_LOW_START
    out dx,al
    mov dx, CRTC_DATA_PORT
    mov al,bl
    out dx,al
	
	inc word [NUMBERSCROLL]
	inc word [WHEN_SCROLLSCREENUP]
	mov ax,[NUMBERSCROLL]
	
	cmp word [TRUE_FALSE2],1
	je .ifnot
	
	call CHECKLINE
	cmp word [TRUE_FALSE], 1
	je .breaks
	
	.ifnot:
	mov word [TRUE_FALSE2], 0
	call CLEARLINE
	
	
	.breaks:
	pop dx
	pop bx
	pop ax
	ret