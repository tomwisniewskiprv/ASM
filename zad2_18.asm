;worksheet  2
;exercise   18

;AH = 07h - DIRECT CHARACTER INPUT, WITHOUT ECHO
;Return: AL = character read from standard input

;Set cursor position
;10h
;AH = 02h  BH = Page Number, DH = Row, DL = Column

;Write character and attribute at cursor position 
;10h
;AH = 09h  AL = Character, BH = Page Number, BL = Color,
;CX = Number of times to print character

; WARNING !
; to compile add /jJUMPS directive

%TITLE "TAIL"
    .8086
    .MODEL small
    .STACK 256
    .DATA
ENTER_KEY equ 0Dh
ESC_KEY equ 1Bh     ; exit
SPACE_KEY equ 20h   ; space
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

tmpByte db 0h

row db 0    ; cursor position
col db 0    ; cursor position
star db "*"
space db 020h 
cursor_visible db 01h

color        db 01fH   ; defualt cursor color
color_yellow db 0EEh

; 0f black bg white cursor
color_grey  db 07fh
color_blue  db 01fh
color_green db 02fh
color_bblue db 0Bfh
color_red   db 04fh
color_pink  db 0Cfh
color_brown db 06fh
color_white db 0F1h


    .CODE
MAIN PROC
    mov ax , @DATA
    mov ds , ax
    mov bx , ESC_KEY
    
   ; cursor starting position
    mov ah , 02h
    mov bh , 00h
    mov bl , color
    mov dx , 00h
    int 10h
    
    jmp printSpace ; first char 0,0
    
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
    
    cmp al , SPACE_KEY ; space
    je tailVisible
    
    cmp al , ESC_KEY
    jne readUntilESC ; loop until ESC
    jmp Exit
    
    ; update cursor poistion
    ; console resolution 80x25 (0-79 x 0-24)
    UP:
    cmp dh , 0
    je border_top
    dec dh
    jmp printCursor
    DOWN:
    cmp dh , 24
    je border_down
    inc dh 
    jmp printCursor
    LEFT:
    cmp dl , 0
    je border_left
    dec dl
    jmp printCursor
    RIGHT:
    cmp dl , 79
    je border_right
    inc dl
    jmp printCursor
    
    ; check edges
    border_top:
    mov dh , 24
    jmp printCursor
    border_down:
    mov dh , 0
    jmp printCursor
    border_left:
    mov dl , 79
    jmp printCursor
    border_right:
    mov dl , 0 
    jmp printCursor
    
    ; colors
    F1:
    mov bl , color_grey
    mov color , bl
    jmp readUntilESC
    F2:
    mov bl , color_blue
    mov color , bl
    jmp readUntilESC
    F3:
    mov bl , color_green
    mov color , bl
    jmp readUntilESC
    F4:
    mov bl , color_bblue
    mov color , bl
    jmp readUntilESC
    F5:
    mov bl , color_red
    mov color , bl
    jmp readUntilESC
    F6:
    mov bl , color_pink
    mov color , bl
    jmp readUntilESC
    F7:
    mov bl , color_brown
    mov color , bl
    jmp readUntilESC
    F8:
    mov bl , color_white 
    mov color , bl
    jmp readUntilESC 
    
    tailVisible:
    mov tmpByte , bl
    mov bl , cursor_visible
    cmp bl , 1
    je swapTailColor    
    mov cursor_visible , 1 ; change cursor status to visible
    jmp readUntilESC
    
    swapTailColor:
    mov cursor_visible , 0 ; change cursor status to invisible
    jmp readUntilESC
        
    ; print char and go back to main loop
    printCursor:
    ; move cursor to new position
    mov ah , 02h
    mov bh , 00h
    int 10h
    
    ; is cursor visible
    mov ah , cursor_visible
    cmp ah , 1
    je printC
    mov bl , 0fh ; if not print blank space
    jmp printSpace
 
    printC: ; if it is print it with current color
    mov bl , color
    jmp printSpace   
    
    printSpace :   
    mov ah , 09h
    mov al , space   ; space char
    mov cx , 01h
    int 10h
       
    jmp readUntilESC ; main loop
    
Exit:
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
END MAIN