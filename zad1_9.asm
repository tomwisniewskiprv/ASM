;worksheet  1
;exercise   9

; Draw a square at cursor position
; Set cursor position int 10h
; AH=02h  BH = Page Number, DH = Row, DL = Column
; https://en.wikipedia.org/wiki/INT_10H

%TITLE "SQUARE2"
    .8086
    .MODEL small
    .STACK 256
    .DATA

    .CODE
MAIN PROC

    ;first row
    mov ah , 02h
    mov bh , 00h
    mov dh , 1
    mov dl , 1
    int 10h
    mov dl , 201 ; upper left corner
    int 21h
    mov dl , 2
    int 10h
    mov dl , 205 ; =
    int 21h
    mov dl , 3
    int 10h
    mov dl , 205 ; =
    int 21h
    mov dl , 4
    int 10h
    mov dl , 187 ; upper right corner
    int 21h
    
    ;second row
    mov ah , 02h
    mov dh , 2
    mov dl , 1
    int 10h    
    mov dl , 186 ; |
    int 21h
    mov dl , 4
    int 10h
    mov dl , 186 ; |
    int 21h
    ; third row
    mov dh , 3
    mov dl , 1
    int 10h
    mov dl , 200 ; lower left
    int 21h
    mov dl , 2
    int 10h
    mov dl , 205 ; =
    int 21h
    mov dl , 3
    int 10h
    mov dl , 205 ; =
    int 21h
    mov dl , 4
    int 10h
    mov dl , 188 ; lower right
    int 21h

Exit:
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
END MAIN