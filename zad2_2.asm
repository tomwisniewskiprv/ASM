;worksheet  2
;exercise   2

;AH=07h - DIRECT CHARACTER INPUT, WITHOUT ECHO
;Return: AL = character read from standard input

%TITLE "NO ECHO"
    .8086
    .MODEL small
    .STACK 256
    .DATA

    .CODE
MAIN PROC

    mov ah , 07h
    int 21h

    mov ah , 02h
    inc al
    mov dl , al
    int 21h    

Exit:
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
END MAIN