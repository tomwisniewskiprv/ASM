;worksheet  2
;exercise   3

;INT 16h AH = 00h - read keystroke
;Return: AL = character read from standard input

%TITLE "STOP WHEN ENTER IS PRESSED"
    .8086
    .MODEL small
    .STACK 256
    .DATA
ENTER_KEY equ 0Dh

    .CODE
MAIN PROC
    
    readUntilEnter:
    mov ah , 00h
    int 16h
    
    mov ah , 02h
    mov dl , al
    int 21h    

    mov bl , ENTER_KEY
    cmp bl , al
    jne readUntilEnter
    
Exit:
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
END MAIN