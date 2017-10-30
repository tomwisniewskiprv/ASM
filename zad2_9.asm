;worksheet  2
;exercise   9

;AH=07h - DIRECT CHARACTER INPUT, WITHOUT ECHO
;Return: AL = character read from standard input

%TITLE "ARROWS TO WSAD"
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

    .CODE
MAIN PROC
    mov ax , @DATA
    mov ds , ax
    mov bx , ESC_KEY
    mov cx , 0
    
    readUntilESC:

    mov ah , 07h
    int 21h
   
    cmp al , U_KEY
    je U2w
    
    cmp al , D_KEY
    je D2z
    
    cmp al , L_KEY
    je L2a
    
    cmp al , R_KEY
    je R2d
    
    cmp al , ESC_KEY
    jne readUntilESC ; loop until ESC
    jmp Exit
    
    ; swap values for ASCII
    U2w:
    mov dl , 77h
    jmp printChar
    D2z:
    mov dl , 7Ah
    jmp printChar
    L2a:
    mov dl , 61h
    jmp printChar
    R2d:
    mov dl , 64h
    jmp printChar
    
    ; print char and go back to main loop
    printChar:
    mov ah , 02h
    int 21h
    jmp readUntilESC
    
Exit:
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
END MAIN