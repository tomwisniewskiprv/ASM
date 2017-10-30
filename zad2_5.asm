;worksheet  2
;exercise   5

;INT 16h AH = 00h - read keystroke
;Return: AL = character read from standard input

%TITLE "READ UNTIL ENTER"
    .8086
    .MODEL small
    .STACK 256
    .DATA
ENTER_KEY equ 0Dh
CHARS dw 010h

    .CODE
MAIN PROC
    mov ax , @DATA
    mov ds , ax
    mov bx , ENTER_KEY
    mov cx , CHARS

    readUntilEnter:
    mov ah , 00h
    int 16h
    
    cmp bl , al ; pressed ENTER ?
    je Exit
    
    mov ah , 02h
    mov dl , 2Ah
    int 21h 
    
    loop readUntilEnter ; loop for 16 times
    
Exit:
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
END MAIN