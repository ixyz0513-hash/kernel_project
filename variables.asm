

val2 db 'Hello',0
val3 db ' world.',0
kernel_version db 'version kernel 0.1',0
message db 'Unkown command',0
arrow db '-->',0
bootmessage db 'Hello this is the kernel hahaha :)',0


debugval_good db 'Good',0
debugval_bad db 'Bad',0

debughigh db 'high',0
debuglow db 'low',0
debugdata db 'data',0  
debugclock db 'clock',0


system_seconds_str db 'system seconds: ',0

valcpy db '                                                                                                             ',0 ; used in strcat to combine two variables into one
bufferstring db 0,0,0,0,0,0,0,0 ; used in itoa function to store  number chars
lengthstring dw 0 ; used in strlen function to store the length of the string

cursor_y dw 4
cursor_x dw 0
cursor_position dw 0 ; used to determine the position of the underline cursor

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
IF_NEGATIVE db 0 ; if negative the string_into_integer function will substract 


CHANGECHARACTER db 0 ; a bool if 0 dont change the al if 1 change it
CHARACTER_NUMBER db 196 ; ascii
CHARACTER_NUMBER2 db 179 ; ascii

IFGRAPHICS_MODE db 0 ; checks if graphics mode


shiftmode db 0 ; checks if user is holding shift
capslock db 0 ; check if user touched capslock

string_type db '                                   ',0 ; used in for storing typed keys
string_length dw 0


align 16
SYSTEM_TICKS dw 0
SYSTEM_SECONDS dw 0
align 16


; below data ports and index ones
CRTC_INDEX_PORT equ 0x3D4
CRTC_DATA_PORT  equ 0x3D5

SEQ_INDEX_PORT  equ 0x3C4
SEQ_DATA_PORT   equ 0x3C5

ATTRIBUTE_DATA_INDEX equ 0x3C0
ATTRIBUTE_READ equ 0x3C1
FLIP_ATTRIBUTE equ 0x3DA


CURSOR_START_REG equ 0x0A
CURSOR_END_REG   equ 0x0B
ADDRESS_HIGH_START equ 0x0C
ADDRESS_LOW_START equ 0x0D

CONTROL_STATUS_REGISTER equ 0x64
DATA_PORT equ 0x60

MASTER_DATA equ 0x20
MASTER_READ_DATA equ 0x21

SLAVE_DATA equ 0xA0
SLAVE_READ_DATA equ 0xA1

CHANNEL_0 equ 0x40
CHANNEL_2 equ 0x42
CHANNEL_WRITE_0_2 equ 0x43
SYSTEM_PORT_B equ 0x61


NON_MASKABLE_INTERRUPT equ 0xA0 ; 0x80 to enable, 0x0 to disable




keyboard_map:
    ; 0x00 - 0x0F
    db 0, 0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 0, 0
    
    ; 0x10 - 0x1F
    db 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 0, 0, 'a', 's'
    
    ; 0x20 - 0x2F
    db 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', "'", '`', 0, '\', 'z', 'x', 'c', 'v'
    
    ; 0x30 - 0x3F
    db 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' ', 0, 0, 0, 0, 0, 0
    
    ; 0x40 - 0x4F
    db 0, 0, 0, 0, 0, 0, 0, '7', 0, '9', '-', 0, '5', 0, '+', '1'
    
    ; 0x50 - 0x56
    db 0, '3', '0', '.', 0, 0, '\'
	


shift_map:
    ; 0x00 - 0x0F
    db 0, 0, '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', 0, 0
    
    ; 0x10 - 0x1F
    db 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', 0, 0, 'A', 'S'
    
    ; 0x20 - 0x2F
    db 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', '"', '~', 0, '|', 'Z', 'X', 'C', 'V'
    
    ; 0x30 - 0x3F
    db 'B', 'N', 'M', '<', '>', '?', 0, '*', 0, ' ', 0, 0, 0, 0, 0, 0
    
    ; 0x40 - 0x4F
    db 0, 0, 0, 0, 0, 0, 0, '7', 0, '9', '-', 0, '5', 0, '+', '1'
    
    ; 0x50 - 0x56
    db 0, '3', '0', '.', 0,0, '\'



commands_strings: ; cmp for cli.asm

    db 'clear',0
    db 'help',0
    db 'ver',0
    db 'echo ',0
    db 'time',0
    db 'beep',0
    db 'add ',0
    db 'sub ',0
    db 0



command_handler: ; the actual functions for this will be in cli.asm

    dw clear_handler
    dw help_handler
    dw ver_handler
    dw echo_handler
    dw time_handler
    dw beep_handler
    dw add_handler
    dw sub_handler
    dw 0
