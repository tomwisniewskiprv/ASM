;worksheet  1
;exercise   6

; Displays whole ASCII table.
; 65 [A]
; 66 [B] ...

.MODEL SMALL
.STACK 64
.DATA
string  db 3 dup (020h), " $" ; range 0 - 255
quotient db 00h
ascii dw 00h    ; A 65 041h , d 100 64h ; ascii table index
charCount dw 0100h ; how many chars to dispaly
base_ten db 0Ah ; base for division  

column dw 0 ; column

.CODE
MAIN PROC

    mov ax , @DATA
    mov ds , ax
    mov cx , charCount   ; display char counter 
    
    PrntLoop:
    mov ax , ascii
    push cx ; save outer loop counter
    mov cx , 03h
    xor bx , bx 
    mov bx , 02h ; writing reminders backwards (starting from position 2 , then 1 ..)
    int2str:
        ; Conversion formula:
        ; value div 10 , save quotient , add 48 to reminder and display it
        ; if quotient < 0 exit
        
        div base_ten    ; divide ax by 10
        mov quotient , al
        add al , 48     ; ascii char | quotient  (iloraz)
        add ah , 48     ; ascii char | reminder  (reszta)
        
        mov string[bx] , ah
        dec bx
       
    ; create word again from quotient    
        mov al , quotient
        mov ah , 0
        cmp al , 0
        jg int2str
    ; end of conversion
    pop cx
    
    ; print value [ char ] CRLF
        lea dx , string 
        mov ah , 09h
        int 21h
        
        mov ah , 02h
        mov dl , 05Bh   ; [
        int 21h

        mov dx , ascii
        int 21h
        
        mov dl , 05Dh   ; ]
        int 21h
        
        mov ah , 02h  
        mov dl , 0Dh    ;CR LF
        int 21h
        mov dl , 0Ah
        int 21h
    
        inc [ascii] ; next char in ascii table
    ; end of print value
    loop PrntLoop

Exit:  
    mov ah, 4ch
    int 21h

MAIN ENDP   ; end of main
END MAIN    ; end of program and execution point
