val2 db 'Hello',0
val3 db ' world.',0
kernel_version db 'version kernel 0.2',0
message db 'Unkown command',0
arrow db '-->',0
bootmessage db 'Hello this is the kernel hahaha :)',0
message2 db 'eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee',0


debugval_good db 'Good',0
debugval_bad db 'Bad',0

debughigh db 'high',0
debuglow db 'low',0
debugdata db 'data',0  
debugclock db 'clock',0

kernel_error db 'error: ',0
kernel_bats db 'BAT failed',0

system_seconds_str db 'system seconds: ',0

valcpy db '                                                                                                             ',0 ; used in strcat to combine two variables into one
bufferstring db 0,0,0,0,0,0,0,0 ; used in itoa function to store  number chars
lengthstring dw 0 ; used in strlen function to store the length of the string

cursor_y dw 4
cursor_x dw 0
cursor_position dw 0 ; used to determine the position of the underline cursor


mouse_x dw 40
mouse_y dw 15

current_color dw 0x7E ; used in clearscreen macro
temporary_color dw 0x5 ; color used in functions like filled rectangle just drawing stuff in general that is not involved with the clear screen macro
shadow_color dw 0x80 ; used in the draw shadow function

temporary1 dw 0 ; used in storing temporary values
temporary2 dw 0 ; used in storing temporary values
temporary3 dw 0 ; used in storing temporary values
temporary4 dw 0 ; used in storing temporary values
slowTemporary1 dw 0 ; only use in nested functions
slowTemporary2 dw 0 ; only use in nested functions


resolutionModeX dw 80
resolutionModeY dw 25
textup_border dw 39
move_cursor_x_times db 1
move_cursor_y_times db 1

HOWMUCHSCROLL dw 0 ; in scrollscreendown you add 80 to it to scroll down one row because the text mode has 80 collumns and after that another row in scrollscreenup it compares it by 0 if it already did scrollscreendown if not it goes to the break label otherwise it substracts it by 80 
NUMBERSCROLL dw 18 ; a number for printing and newline macro when to scrolldown when you scroll down it increments it scroll screen up then decrements it
WHEN_SCROLLSCREENUP dw 0

TRUE_FALSE db 0 ; just a bool
TRUE_FALSE2 db 0 ; just a bool
IFRIGHT_CORNER db 0
TRUE_FALSE_STRCMP db 0 ; just a bool used in strcmp
TRUE_FALSE_WINDOW db 0 ; if 1 draw window else draw rectangle
IF_BOOT_ENDED db 0 ; if boot ended call displaytime every 1 second
IF_NEGATIVE db 0 ; if true the string_into_integer function will substract
FROM_CLI db 0 ; if true the end_character will be 0x20(space)
CHECK_STOPWATCH db 0 ; set by stopwatch_handler to make the pit check time_wait
IF_FROM_TEXTUP db 0 ; if 1 the cursor_x if it equals set value newline


CHANGECHARACTER db 0 ; a bool if 0 dont change the al if 1 change it
CHARACTER_NUMBER db 196 ; ascii
CHARACTER_NUMBER2 db 179 ; ascii

IFGRAPHICS_MODE db 0 ; checks if graphics mode


string_type db '                                   ',0 ; used in for storing typed keys
string_length dw 0
end_character db 0x0

buttons_position_x1 dw 0,0,0,0,0,0,0,0,0,0
buttons_position_x2 dw 0,0,0,0,0,0,0,0,0,0
buttons_position_y1 dw 0,0,0,0,0,0,0,0,0,0
buttons_position_y2 dw 0,0,0,0,0,0,0,0,0,0
current_button db 0

SYSTEM_TICKS dw 0
SYSTEM_SECONDS dw 0
TIME_WAIT dw 0 ; WHEN TO BEEP SET BY STOPWATCH


; below data ports and index ones
CRTC_INDEX_PORT equ 0x3D4
CRTC_DATA_PORT  equ 0x3D5

ATTRIBUTE_DATA_INDEX equ 0x3C0
ATTRIBUTE_READ equ 0x3C1
FLIP_ATTRIBUTE equ 0x3DA

CONTROL_STATUS_REGISTER equ 0x64
DATA_PORT equ 0x60

OUTPUT_PORT_READ equ 0xD0
OUTPUT_PORT_WRITE equ 0xD1


NON_MASKABLE_INTERRUPT equ 0xA0 ; 0x80 to enable, 0x0 to disable