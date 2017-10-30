;worksheet  2
;exercise   7

;INT 16h AH = 00h - read keystroke
;Return: AL = character read from standard input

%TITLE "SHOW PASSWORD"
    .8086
    .MODEL small
    .STACK 256
    .DATA
ENTER_KEY equ 0Dh
CHARS dw 010h

PassOkay db 0Dh , 0Ah ,"Password OKAY" , 0Dh , 0Ah , "$"
PassFail db 0Dh , 0Ah ,"Password FAIL" , 0Dh , 0Ah , "$"

buffer db 16+1 dup (0) , "$"    ; password buffer
buffB db 1 ; byte buffer

    .CODE
MAIN PROC
    mov ax , @DATA
    mov ds , ax

    mov cx , 0
    
    readUntilEnter:
    mov bx , ENTER_KEY
    mov ah , 00h
    int 16h
    
    mov buffB , al
    cmp bl , al ; pressed ENTER ?
    je CheckLength
    
    mov ah , 02h
    mov dl , 2Ah ; *
    int 21h
    
    mov bx , cx
    mov al , buffB
    mov buffer[bx] , al 
    inc cx
    cmp cx , CHARS
    jle readUntilEnter ; loop for 16 times
    
    CheckLength:
    cmp cx , CHARS
    jl PassOK
    
    PassWrong:
    lea dx , PassFail
    mov ah , 09h
    int 21h
    jmp Exit
    
    PassOK:
    lea dx , PassOkay
    mov ah , 09h
    int 21h
    
    PassShow:
    lea dx , buffer
    mov ah , 09h
    int 21h
    
Exit:
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
END MAIN