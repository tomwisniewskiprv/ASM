;worksheet  1
;exercise   10

; To zadanie jest identyczne z zadaniami 7 , 8 , 9
%TITLE "SQUARE with ASCII 177"
    .8086
    .MODEL small
MAINSTACK SEGMENT STACK 
    dw 1024 dup(?) 
    sptr label word
    
MAINSTACK ENDS
DATA SEGMENT
    
    ; To display square just modify it's length and base row/column to draw 
    ; figure somewhere else
    
    lenght_w equ 31     ; border lenght , it shouldn't equal 0 !
    lenght_h equ 8      ; border heigth
    
    base_row   equ 5 ; coordinates of top left corner - row
    base_col   equ 7 ;                                - column
    
    tl_corner db base_row                , base_col               ; row 1 , col 1
    tr_corner db base_row                , base_col + lenght_w + 1  ; row 1 , col 2
    bl_corner db base_row + lenght_h + 1 , base_col               ; row 2 , col 1
    br_corner db base_row + lenght_h + 1 , base_col + lenght_w + 1  ; row 2 , col 2

    color    equ 7fh ; border color
    bg_color equ 70H ; background color
    
    ascii_chr equ 20h;177 ; background ascii char
    
    msg1 db "Zestaw 1 - Zadanie 11" , "$"
    msg2 db "12.11.2017 Uniwersytet Slaski" , "$" ; len 30
    msg3 db "Turbo Assembler" , "$"
    msg4 db "Autor: Tomasz Wisniewski" , "$"
    msgAbout db " About " , "$"
    msgOK    db "OK" , "$"
    
    
DATA ENDS
CODE SEGMENT
    assume cs:code , ds:data
MAIN PROC
   ; Load data segments
    mov ax , seg data
    mov ds , ax
    
    mov ax , mainstack
    mov ss , ax
    mov sp , offset sptr
    
    ; main loop
    call DrawBackground
    call DrawBorder
    call DrawCorners
    call DrawText
    call DrawClose
    call DrawOk
    
Exit:
    mov dh , bl_corner[0]
    add dh , 2
    mov dl , bl_corner[1]
    mov ah , 02h
    int 10h
    
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
; Set cursor position: int 10h    AH=02h  BH = Page Number, DH = Row, DL = Column

; Write character and attribute at cursor position :
; int 10h    AH=09h  AL = Character, BH = Page Number, BL = Color, CX = Number of times 

DrawBackground PROC
    mov bh , 0         ; page number
    mov al , ascii_chr ; space
    mov bl , bg_color  ; background color
        
    mov dh , tl_corner[0]  ; left top corner
    add dh , 1             ; add 1 to corner cordinates
    mov dl , tl_corner[1]
    add dl , 1
    
    mov ah , 02h
    int 10h
    
    mov cx , lenght_h ; height

    draw_next_row:
    push cx
    
    mov ah , 02h
    mov dl , tl_corner[1] ; reset column
    add dl , 1
    int 10h
    
    mov cx , lenght_w ; width
    draw_background:
        push cx
        mov ah , 09h
        mov cx , 01h
        int 10h
        
        mov ah , 02h
        inc dl     ; next column
        int 10h
        
        pop cx
        loop draw_background
    inc dh     ; next row
    pop cx
    loop draw_next_row
    
    ret
DrawBackground ENDP 


DrawBorder PROC
    mov bh , 0   ; page number
    mov al , 205 ; border char
    mov bl , color ; grey color ?
        
    ; horizontal borders
    mov dh , tl_corner[0]  ; top left corner
    mov dl , tl_corner[1]
    mov ah , 02h
    int 10h
    
    mov cx , lenght_w ; width
    add cx , 2
    draw_top_border:
        push cx
        mov ah , 09h
        mov cx , 01h
        int 10h
        
        mov ah , 02h
        inc dl     ; next column
        int 10h
        
        pop cx
        loop draw_top_border
    
    mov dh , bl_corner[0]  ; bottom left corner
    mov dl , bl_corner[1]
    mov ah , 02h
    int 10h
    
    mov cx , lenght_w ; width
    add cx , 2
    draw_bottom_border:
        push cx
        mov ah , 09h
        mov cx , 01h
        int 10h
        
        mov ah , 02h
        inc dl     ; next column
        int 10h
        
        pop cx
        loop draw_bottom_border
  
    ; vertical borders  
    mov bh , 0   ; page number
    mov al , 186 ; border char
    mov bl , 7fh ; grey color ?  
    
    mov dh , tl_corner[0]  ; top left corner
    mov dl , tl_corner[1]
    mov ah , 02h
    int 10h
    
    mov cx , lenght_h ; height
    add cx , 2
    draw_left_border:
        push cx
        mov ah , 09h
        mov cx , 01h
        int 10h
        
        mov ah , 02h
        inc dh     ; next row
        int 10h
        
        pop cx
        loop draw_left_border    
    
    mov dh , tr_corner[0]  ; top right corner
    mov dl , tr_corner[1]
    mov ah , 02h
    int 10h
    
    mov cx , lenght_h ; height
    add cx , 2
    draw_right_border:
        push cx
        mov ah , 09h
        mov cx , 01h
        int 10h
        
        mov ah , 02h
        inc dh     ; next row
        int 10h
        
        pop cx
        loop draw_right_border    
           
    ret
DrawBorder ENDP

DrawCorners PROC
    mov bh , 0     ; page number
    mov bl , color ; color
        
    ; top left corner
    mov al , 201 ; border char
    mov dh , tl_corner[0]  
    mov dl , tl_corner[1]
    mov ah , 02h
    int 10h
    
    mov ah , 09h
    mov cx , 01h
    int 10h
        
    ; top right corner
    mov al , 187 ; border char
    mov dh , tr_corner[0]  
    mov dl , tr_corner[1]
    mov ah , 02h
    int 10h
    
    mov ah , 09h
    mov cx , 01h
    int 10h
          
    ; bottom left corner
    mov al , 200 ; border char
    mov dh , bl_corner[0]  
    mov dl , bl_corner[1]
    mov ah , 02h
    int 10h
    
    mov ah , 09h
    mov cx , 01h
    int 10h
 
    ; bottom right corner
    mov al , 188 ; border char
    mov dh , br_corner[0]  
    mov dl , br_corner[1]
    mov ah , 02h
    int 10h
    
    mov ah , 09h
    mov cx , 01h
    int 10h
    
    ret 
DrawCorners ENDP

DrawText PROC
    ; about
    mov dh , tl_corner[0] 
    mov dl , tl_corner[1]
    add dl , 13
    mov ah , 02h
    mov bl , 55h
    int 10h
    
    mov ah , 09h
    lea dx , msgAbout
    int 21h
    
    ; msg 1
    mov dh , tl_corner[0] 
    add dh , 2
    mov dl , tl_corner[1]
    add dl , 2
    mov bl , 10h
    mov ah , 02h
    int 10h
    
    mov ah , 09h
    lea dx , msg1
    int 21h

    ; msg 2
    mov dh , tl_corner[0] 
    add dh , 3
    mov dl , tl_corner[1]
    add dl , 2
    mov bl , 10h
    mov ah , 02h
    int 10h
    
    mov ah , 09h
    lea dx , msg2
    int 21h

    ; msg 3
    mov dh , tl_corner[0] 
    add dh , 4
    mov dl , tl_corner[1]
    add dl , 2
    mov bl , 10h
    mov ah , 02h
    int 10h
    
    mov ah , 09h
    lea dx , msg3
    int 21h

    ; msg 4
    mov dh , tl_corner[0] 
    add dh , 5
    mov dl , tl_corner[1]
    add dl , 2
    mov bl , 10h
    mov ah , 02h
    int 10h
    
    mov ah , 09h
    lea dx , msg4
    int 21h
    
    ret
DrawText ENDP

DrawClose PROC
    mov bh , 0   ; page number
    mov bl , 7fh ; color
        
    ; top left corner
    mov al , "[" ; [ char
    mov dh , tl_corner[0]  
    mov dl , tl_corner[1]
    inc dl
    inc dl
    mov ah , 02h
    int 10h
    
    mov ah , 09h
    mov cx , 01h
    int 10h
    
    mov al , "]" ; [ char
    inc dl
    inc dl
    mov ah , 02h
    int 10h
    
    mov ah , 09h
    mov cx , 01h
    int 10h
    
    mov al , 254 ; square char
    dec dl
    mov bl , 7Ah
    mov ah , 02h
    int 10h
    
    mov ah , 09h
    mov cx , 01h
    int 10h
    
    ret
DrawClose ENDP
DrawOK PROC
 ; Draw OK
    mov dh , tl_corner[0]  
    add dh , 7
    mov dl , tl_corner[1]
    add dl , 12
    mov bl , 02Fh
    mov ah , 02h
    int 10h
    
    mov cx , 8
    mov ah , 09h
    mov al , " "
    green_bg:
    inc dl
    int 10h
    loop green_bg
    
    mov dl , tl_corner[1]
    add dl , 15
    mov ah , 02h
    int 10h
    
    mov ah , 09h
    lea dx , msgOK
    int 21h
    ret
DrawOK ENDP


CODE ENDS
END MAIN