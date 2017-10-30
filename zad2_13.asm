;worksheet  2
;exercise   13

;AH = 07h - DIRECT CHARACTER INPUT, WITHOUT ECHO
;Return: AL = character read from standard input

;Set cursor position
;10h
;AH = 02h  BH = Page Number, DH = Row, DL = Column

;Write character and attribute at cursor position 
;10h
;AH = 09h  AL = Character, BH = Page Number, BL = Color,
;CX = Number of times to print character

%TITLE "LEAVE A RED TRACE"
    .8086
    .MODEL small
    .STACK 256
    .DATA
ENTER_KEY equ 0Dh
ESC_KEY equ 1Bh ; exit
U_KEY equ 48h
D_KEY equ 50h
L_KEY equ 4Bh
R_KEY equ 4Dh

row db 0
col db 0
star db "*"
space db 020h 

color_red db 0CCh
color_blue db 099h
color_yellow db 0EEh
color_green db 0AAh

    .CODE
MAIN PROC
    mov ax , @DATA
    mov ds , ax
    mov bx , ESC_KEY
    
    ; cursor starting position
    mov ah , 02h
    mov bh , 00h
    mov dx , 00h
    int 10h
    
    readUntilESC:
    mov ah , 07h
    int 21h
   
    cmp al , U_KEY
    je UP
    
    cmp al , D_KEY
    je DOWN
    
    cmp al , L_KEY
    je LEFT
    
    cmp al , R_KEY
    je RIGHT
    
    cmp al , ESC_KEY
    jne readUntilESC ; loop until ESC
    jmp Exit
    
    ; update cursor poistion
    ; console resolution 80x25 (0-79 x 0-24)
    UP:
    cmp dh , 0
    je printCursor
    dec dh
    jmp printCursor
    DOWN:
    cmp dh , 24
    je printCursor
    inc dh 
    jmp printCursor
    LEFT:
    cmp dl , 0
    je printCursor
    dec dl
    jmp printCursor
    RIGHT:
    cmp dl , 79
    je printCursor
    inc dl
    jmp printCursor
    
    ; print char and go back to main loop
    printCursor:
    ; move to new position
    mov ah , 02h
    mov bl , color_red
    mov bh , 00h
    int 10h
    
    ; print space 
    mov ah , 09h
    mov al , space   ; space
    mov cx , 01h
    int 10h
       
    jmp readUntilESC
    
Exit:
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
END MAIN