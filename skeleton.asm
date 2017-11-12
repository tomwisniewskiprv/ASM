;asm skeleton v2

;worksheet  1
;exercise   1

%TITLE "SKELETON"
    .8086
    .MODEL small
MAINSTACK SEGMENT STACK 
    dw 1024 dup(?) 
    sptr label word
    
MAINSTACK ENDS
DATA SEGMENT

DATA ENDS
CODE SEGMENT
    assume cs:code , ds:data
MAIN PROC
   ; Load data segments
    mov ax , seg data
    mov ds , ax
    
    mov ax , mainstack
    mov ss , ax
    mov sp , offset sptr

Exit:

    mov ah , 4Ch
    int 21h
    
MAIN ENDP
CODE ENDS
END MAIN