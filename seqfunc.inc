
TURNSCREEN_OFF:
      push dx
	  push ax
	  
	  mov dx, SEQ_INDEX_PORT
	  mov al,0x1
	  out dx,al
	  
	  mov dx, SEQ_DATA_PORT
	  in al,dx
	  or al,32
	  out dx,al
	  
      pop ax
	  pop dx
      ret

TURNSCREEN_ON:
      push dx
	  push ax
	  
	  mov dx, SEQ_INDEX_PORT
	  mov al,0x1
	  out dx,al
	  
	  mov dx, SEQ_DATA_PORT
	  in al,dx
	  and al,223
	  out dx,al
	  
      pop ax
	  pop dx
      ret
	  
	  
	  

DOTCLOCK_9:
    push dx
	push ax
	
	mov dx, SEQ_INDEX_PORT
	mov ax, 0x0100
	out dx,ax

    mov dx, SEQ_INDEX_PORT
    mov al,0x1
    out dx,al
	  
	mov dx, SEQ_DATA_PORT
	in al,dx
	and al,254
	out dx,al
	
	mov dx, SEQ_INDEX_PORT
	mov ax, 0x0300
	out dx,ax
	
	
	pop ax
	pop dx
	ret
	  
	  
	  

DOTCLOCK_8:
    push dx
	push ax
	
	mov dx, SEQ_INDEX_PORT
	mov ax, 0x0100
	out dx,ax

    mov dx, SEQ_INDEX_PORT
	mov al,0x1
	out dx,al
	  
	mov dx, SEQ_DATA_PORT
	in al,dx
	or al,1
	out dx,al
	
	mov dx, SEQ_INDEX_PORT
	mov ax, 0x0300
	out dx,ax
	
	
	pop ax
	pop dx
	ret
	
	
