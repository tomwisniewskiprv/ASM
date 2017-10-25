;worksheet  1
;exercise   7

; Draw a square.

%TITLE "SQUARE"
    .8086
    .MODEL small
    .STACK 256
    .DATA

    .CODE
MAIN PROC
    mov ah , 02h
    mov dl , 201 ; 1
    int 21h
    mov dl , 205 ; =
    int 21h
    int 21h
    mov dl , 187 ; 2
    int 21h
    
    mov dl , 0Dh
    int 21h
    mov dl , 0Ah
    int 21h
    
    mov dl , 186 ; |
    int 21h
    mov dl , 32
    int 21h
    int 21h
    mov dl , 186
    int 21h
    
    mov dl , 0Dh
    int 21h
    mov dl , 0Ah
    int 21h
    
    mov dl , 200 ; 3
    int 21h
    mov dl , 205 ; =
    int 21h
    int 21h
    mov dl , 188 ; 4
    int 21h

Exit:
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
END MAIN