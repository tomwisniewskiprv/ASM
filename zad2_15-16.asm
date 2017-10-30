;worksheet  2
;exercise   15-16

;AH = 07h - DIRECT CHARACTER INPUT, WITHOUT ECHO
;Return: AL = character read from standard input

;Set cursor position
;10h
;AH = 02h  BH = Page Number, DH = Row, DL = Column

;Write character and attribute at cursor position 
;10h
;AH = 09h  AL = Character, BH = Page Number, BL = Color,
;CX = Number of times to print character

%TITLE "FUNCTION KEYS WITH COLORS"
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

F1_KEY equ 3Bh
F2_KEY equ 3Ch
F3_KEY equ 3Dh
F4_KEY equ 3Eh
F5_KEY equ 3Fh
F6_KEY equ 40h
F7_KEY equ 41h
F8_KEY equ 42h

row db 0
col db 0
star db "*"
space db 020h 

color_update db 00H
color_yellow db 0EEh

color_grey db 077h
color_blue db 011h
color_green db 022h
color_bblue db 0BBh
color_red db 044h
color_pink db 0CCh
color_brown db 066h
color_white db 0FFh


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
    
    ; Function keys go here
    cmp al , F1_KEY
    je F1
    cmp al , F2_KEY
    je F2
    cmp al , F3_KEY
    je F3
    cmp al , F4_KEY
    je F4
    cmp al , F5_KEY
    je F5
    cmp al , F6_KEY
    je F6
    cmp al , F7_KEY
    je F7
    cmp al , F7_KEY
    je F8
    
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
    
    ; colors
    F1:
    mov bl , color_grey
    jmp printCursor
    F2:
    mov bl , color_blue
    jmp printCursor
    F3:
    mov bl , color_green
    jmp printCursor
    F4:
    mov bl , color_bblue
    jmp printCursor
    F5:
    mov bl , color_red
    jmp printCursor
    F6:
    mov bl , color_pink
    jmp printCursor
    F7:
    mov bl , color_brown
    jmp printCursor
    F8:
    mov bl , color_white 
    jmp printCursor
    
    
    ; print char and go back to main loop
    printCursor:
    ; move to new position
    mov ah , 02h
    mov bh , 00h
    int 10h
    
    ; print space 
    mov ah , 09h
    mov al , space   ; space
    mov cx , 01h
    int 10h
       
    jmp readUntilESC ; main loop
    
Exit:
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
END MAIN