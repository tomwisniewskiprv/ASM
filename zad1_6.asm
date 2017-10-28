;worksheet  1
;exercise   6

; Displays whole ASCII table.
; 65 [A]
; 66 [B] ...

.MODEL SMALL
.STACK 64
.DATA
string  db 3 dup (0), "$"
tmpWord dw ?
tmpByte db 43h
ascii dw 041h
base_ten db 0Ah
.CODE
MAIN PROC

    mov ax , @DATA
    mov ds , ax
    mov cx , 0Ah   ; display char counter 
    
    PrntLoop:
    ;push cx
    ;mov cx , 3
    mov ax , ascii
    c:
    ; Conversion formula:
    div base_ten    ; divide ax by 10
    mov bl , al
    add al , 48     ; ascii char
    add ah , 48     ; ascii char
    mov tmpByte , al
    mov bh , ah
    ;add dl , 48     ; quotient  (iloraz)
    ;add dh , 48     ; reminder  (reszta)
    mov ah , 02h
    mov dl , 05Bh   ; [
    int 21h
    mov dl , tmpByte; quotient
    int 21h
    mov dl , bh     ; reminder
    int 21h
    mov dx , [ascii]
    int 21h
    mov dl , 05Dh   ; ]
    int 21h
   
    ; create word again from quotient
    mov al , bl
    mov ah , 0
    cmp al , 10
    jg c
    ; end of conversion
    ;pop cx
    inc [ascii]
    
    
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
END MAIN    ; end of program and execution point
