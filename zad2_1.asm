;worksheet  2
;exercise   1

;AH = 01h - READ CHARACTER FROM STANDARD INPUT, WITH ECHO
;Return: AL = character read

%TITLE "ECHO"
    .8086
    .MODEL small
    .STACK 256
    .DATA

    .CODE
MAIN PROC

    mov ah , 01h
    int 21h

    mov ah , 02h
    mov dl , al
    int 21h    

Exit:
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
END MAIN