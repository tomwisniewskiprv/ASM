;worksheet  1
;exercise   10

; Font and background colors
; Write character and attribute at cursor position
; AH=09h  AL = Character, BH = Page Number, BL = Color, 
; CX = Number of times to print character

; Set background/border color
; AH=0Bh, BH = 00h BL = Background/Border color (border only in text modes)

%TITLE "SQUARE"
    .8086
    .MODEL small
    .STACK 256
    .DATA

    .CODE
MAIN PROC
    mov ah , 9
    mov bh , 0
    mov cx , 1
    mov bl , 0  ; color
    int 10h 
   
    mov ah , 02h
    mov dl , 201 ; 1
    int 21h
    inc bl
    mov ah , 09h
    int 10h
    mov ah , 02h
    mov dl , 205 ; =
    int 21h
    inc bl
    mov ah , 09h
    int 10h
    mov ah , 02h
    int 21h
    inc bl
    mov ah , 09h
    int 10h
    mov ah , 02h
    mov dl , 187 ; 2
    int 21h
    
    mov dl , 0Dh
    int 21h
    mov dl , 0Ah
    int 21h
    
    inc bl
    mov ah , 09h
    int 10h
    mov ah , 02h
    mov dl , 186 ; |
    int 21h
    inc bl
    mov ah , 09h
    int 10h
    mov ah , 02h
    mov dl , 32
    int 21h
    inc bl
    mov ah , 09h
    int 10h
    mov ah , 02h
    int 21h
    inc bl
    mov ah , 09h
    int 10h
    mov ah , 02h
    mov dl , 186
    int 21h
    
    mov dl , 0Dh
    int 21h
    mov dl , 0Ah
    int 21h
    
    inc bl
    mov ah , 09h
    int 10h
    mov ah , 02h
    mov dl , 200 ; 3
    int 21h
    inc bl
    mov ah , 09h
    int 10h
    mov ah , 02h
    mov dl , 205 ; =
    int 21h
    inc bl
    mov ah , 09h
    int 10h
    mov ah , 02h
    int 21h
    inc bl
    mov ah , 09h
    int 10h
    mov ah , 02h
    mov dl , 188 ; 4
    int 21h

Exit:
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
END MAIN