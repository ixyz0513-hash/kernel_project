NEWLINE:

    CHECKIF_SCROLLDOWN
    call CURSOR_GO
    ret

NEWLINECLI:
	call NEWLINE
	push arrow
	call PRINT
	mov word [cursor_x], 3
	call CURSOR_GO
    ret


NEWLINEUP:

    CHECKIF_SCROLLUP
    mov word [cursor_x], 0
    call CURSOR_GO
    ret

