;worksheet  1
;exercise   6

; Displays whole ASCII table.
; 65 [A]
; 66 [B] ...

.MODEL SMALL
.STACK 64
.DATA
chars db 3 dup (?)
.CODE
MAIN PROC

    mov cx , 01Ah   ; char counter , counting backwards
    mov bx , 41h    ; ascii values
    
    PrntLoop:
    ; Conversion formula:
    ; # TODO # finish the loop
    mov ax , bx
    push bx         ; save bx
    mov bx , 10
    div bl
    pop bx          ; restore bx
    mov dl , al
    mov dh , ah 
    add dl , 48     ; quotient  (iloraz)
    add dh , 48     ; reminder  (reszta)
    mov chars , dh
    push dx
    mov ah , 02h
    int 21h
    mov dl , dh
    int 21h
    ; end of conversion
    
    ;
    mov dl , 05Bh   ; [
    int 21h
    mov dl , bl
    int 21h
    mov dl , 05Dh   ; ]
    int 21h
    
    inc bx
    
    Endline:
        mov dl , 0Dh    ;CR LF
        int 21h
        mov dl , 0Ah
        int 21h
    
    loop PrntLoop

Exit:  
    mov ah, 4ch
    int 21h

MAIN ENDP   ; end of main
END MAIN    ;end of program and execution point
