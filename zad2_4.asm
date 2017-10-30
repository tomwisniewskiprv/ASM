;worksheet  2
;exercise   4

;INT 16h AH = 00h - read keystroke
;Return: AL = character read from standard input

%TITLE "STARS"
    .8086
    .MODEL small
    .STACK 256
    .DATA
ENTER_KEY equ 0Dh

    .CODE
MAIN PROC
    mov ax , @DATA
    mov ds , ax
    mov bl , ENTER_KEY
    
    readUntilEnter:
    mov ah , 00h
    int 16h
    
    cmp bl , al
    
    mov ah , 02h
    mov dl , 2Ah
    int 21h 
    
    jne readUntilEnter
 
Exit:
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
END MAIN