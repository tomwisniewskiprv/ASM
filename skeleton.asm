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
    mov dl , "A"
    
    
    mov ax , 79
    cmp ax , 80
    jl less80   ; 80 - 100
    sub ax , 21 ; 80 + 20 = 100 , 80 = 100 - 20 , 79 = 100 - 21
    
    less80:     ; 0 - 79
    mov ah , 02h
    int 21h
    ; ====================
    
    mov ax , 99
    cmp ax , 50 ; 99 - 50 = 49 ; less
    jl less50   ; 50 + 50 = 100 , 50 = 100 - 50 , 49 = 100 - 51 , 
    
    less50:
    mov dl , "4"
    mov ah , 02h
    int 21h
    mov dl , "9"
    mov ah , 02h
    int 21h
    
    
    less24: ; 23
    
    
Exit:

    mov ah , 4Ch
    int 21h
    
MAIN ENDP
CODE ENDS
END MAIN