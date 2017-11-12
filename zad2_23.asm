;worksheet  2
;exercise   23

%TITLE "Random 25 stars with colors"
    .8086
    .MODEL small
MAINSTACK SEGMENT STACK 
    dw 1024 dup (?)
    pointer label word
MAINSTACK ENDS
;-----------------------------;
;   DATA SEGEMENT             ;
;-----------------------------;
DATA SEGMENT   
stars      equ 25  ; store 25 stars    
                   
            ; star recognition constants 
r_star     equ 04h ; red star
b_star     equ 01h ; blue star
g_star     equ 02h ; green star

            ; speed modification values
delay      dw  0FFFFh ; delay interval , snake's speed , lower = faster
interval   equ 1F4h   ; basic value 
r_interval equ interval         ; red star interval
b_interval equ interval * 2     ; blue star interval
g_interval equ interval * 3     ; green star inverval

star_row   db stars dup (00h) ; row
star_col   db stars dup (00h) ; column
star_clr   db stars dup (00h) ; color

star_count db stars ; stars left on screen

sys_time   db 00h   ; saved system time
    
direction  db 00h   ; snake's movement direction 
                    ; 0 - right , 1 - down , 2 - left , 3 - up

snake_len  equ 0Ah  ; length of snake
sl         db snake_len
snake_row  db snake_len dup (00h) ; snake cords data
snake_col  db snake_len dup (00h) ; snake cords data

head_dl    db 00h   ; updated head and tail coordinates
head_dh    db 00h   
tail_dl    db 00h
tail_dh    db 00h  

is_snake_visible db 0 ; status flag for first 10 moves, when it's less then ten
                      ; first position 0,0 will be displayed. main goal is to simulate
                      ; snake's roll out.

ENTER_KEY equ 0Dh
ESC_KEY   equ 1Bh ; exit
SPACE_CHR equ 20h

U_KEY equ 48h   ; arrow keys
D_KEY equ 50h
L_KEY equ 4Bh
R_KEY equ 4Dh

F1_KEY equ 3Bh  ; function keys
F2_KEY equ 3Ch
F3_KEY equ 3Dh
F4_KEY equ 3Eh
F5_KEY equ 3Fh
F6_KEY equ 40h
F7_KEY equ 41h
F8_KEY equ 42h

row     db 0
col     db 0
star    db "*"

color        db 5fh ; current color
color_bg     db 00h

color_yellow db 0EEh
color_grey   db 07Fh
color_blue   db 01Fh
color_green  db 02Fh
color_bblue  db 0BFh ; bright blue
color_red    db 04Fh
color_pink   db 0CFh
color_brown  db 06Fh
color_white  db 0FFh

msg1 db "Generating stars , please wait." , 0Dh , 0Ah , "$"
msg2 db "ESC pressed , exiting." , 0Dh , 0Ah , "$"
msg3 db "You have won! thanks for playing!" , 0Dh , 0Ah , "$"

DATA ENDS
;-----------------------------;
;   END OF DATA SEGEMENT      ;
;-----------------------------;

;-----------------------------;
;   CODE SEGEMENT             ;
;-----------------------------;
CODE SEGMENT
    ASSUME CS:CODE , DS:DATA , SS:MAINSTACK
Main PROC
    ; program initialization routines
    mov ax , seg DATA   ; load data segment
    mov ds , ax
    
    mov ax , seg MAINSTACK ; load stack segment
    mov ss , ax
    
    mov sp , offset pointer ; set stack pointer
        
    mov ah , 01h    ; hide blinking cursor
    mov ch , 2Bh
    mov cl , 0Bh
    int 10h
    
    ; generate stars data
    call GenerateStars   
    
    ; clear screen
    call ClrScr

    ; cursor starting position
    mov ah , 02h
    mov bh , 00h   ; page
    mov bl , color ; color
    xor dx , dx    ; starting position dh , dl
    int 10h
    
    ; start, main loop execution point
    jmp printSnake ; first position 0,0 , start main loop

    ; main loop
    readUntilESC:
    
    mov ah , 0Bh    ; check stdin status , returns al
    int 21h
    cmp al , 00h    ; there is nothing in queue
    je continue_mov
    
    mov ah , 07h    ; read keyboard input
    int 21h
    
    ; 0 - right , 1 - down , 2 - left , 3 - up
    cmp al , U_KEY
    je Change_dir_UP
    cmp al , D_KEY
    je Change_dir_DOWN
    cmp al , L_KEY
    je Change_dir_LEFT    
    cmp al , R_KEY
    je Change_dir_RIGHT
    
    ; function keys go here
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
    
    call ClrScr
    lea dx , msg2    ; display "Pressed ESC"
    mov ah , 09h
    int 21h
    
    jmp Exit
    
    ; 0 - right , 1 - down , 2 - left , 3 - up
    Change_dir_RIGHT:
    mov direction , 00h
    jmp continue_mov 
    
    Change_dir_DOWN:
    mov direction , 01h
    jmp continue_mov 
    
    Change_dir_LEFT:
    mov direction , 02h
    jmp continue_mov 
    
    Change_dir_UP:
    mov direction , 03h
    jmp continue_mov 
    
    ; decide where to move head
    continue_mov:
    cmp direction , 03h
    je UP
    cmp direction , 01h
    je DOWN
    cmp direction , 02h
    je LEFT
    cmp direction , 00h
    je RIGHT
    
    ; check console borders. resolution 80x25 (0-79 x 0-24)
    UP:
    cmp dh , 0
    je border_top
    dec dh
    jmp update_head
    DOWN:
    cmp dh , 23
    je border_down
    inc dh 
    jmp update_head
    LEFT:
    cmp dl , 0
    je border_left
    dec dl
    jmp update_head
    RIGHT:
    cmp dl , 79
    je border_right
    inc dl
    jmp update_head
    
    ; check edges
    border_top:
    mov dh , 23
    jmp update_head
    border_down:
    mov dh , 0
    jmp update_head
    border_left:
    mov dl , 79
    jmp update_head
    border_right:
    mov dl , 0 
    jmp update_head
    
    ; colors
    F1:
    mov bl , color_grey
    jmp update_color
    F2:
    mov bl , color_blue
    jmp update_color
    F3:
    mov bl , color_green
    jmp update_color
    F4:
    mov bl , color_bblue
    jmp update_color
    F5:
    mov bl , color_red
    jmp update_color
    F6:
    mov bl , color_pink
    jmp update_color
    F7:
    mov bl , color_brown
    jmp update_color
    F8:
    mov bl , color_white 
    jmp update_color
    
    ; update variables
    update_color:
    mov color , bl
    jmp printSnake
    
    update_head: ; save new head position
    mov head_dl , dl
    mov head_dh , dh
    
    call CheckStarAt
    
    update_snake:
    call UpdateSnake
    
    printSnake:    
    call DrawSnake
   
    call DrawStars
   
    call DelayProc
    
    jmp readUntilESC ; main loop
    
Exit:
    mov ah , 4Ch
    int 21h

Exit_win:           
    call ClrScr
    lea dx , msg3
    mov ah , 09h
    int 21h
    jmp Exit
    
Main ENDP

;-----------------------------;
;   PROCEDURES                ;
;-----------------------------;
;=====================================================================
DelayProc PROC
; Delay between next frames     

; INT 15h / AH = 86h - BIOS wait function

; INT 15H 86H: Wait
; Expects: AH    86H
; CX:DX = interval in microseconds  

; CX is high word, DX is low word

    push dx ; save current head position 
    mov cx , 00h    ; #delay
    
    mov dx , delay
    mov ah , 86h
    int 15h
    pop dx
    
    ret
DelayProc ENDP
;=====================================================================
GenerateStars PROC
; Procedure generates random star's coordinates and color
; based on local time
 
    push ax
    push bx
    push cx
    push dx
    
    lea dx , msg1 ; display "please be patient"
    mov ah , 09h
    int 21h
    
    xor ax , ax
    xor bx , bx
    xor cx , cx
    xor dx , dx
    
    next_c:
    push cx
    mov cx , 02h
    mov dx , 50h
    mov ah , 86h ; delay
    mov al , 00h
    int 15h
    
    ; random column ======================
    mov ah , 2ch ; get system time
    int 21h      ; CH = hours CL = minutes DH=seconds DL=1/100s microseconds
    xor ax , ax
    mov al , dl
    
    cmp al , 80
    jl le80    ; if dl less equal 80 
    sub al , 20 ; substract 20 to get random column value
    le80:
    mov col , al
    
    pop cx
    mov al , col
    mov bx , cx
    mov star_col[bx] , al
    push cx
    
    ; random row ==========================
    mov cx , 01h
    mov dx , 70h
    mov ah , 86h ; delay
    mov al , 00h
    int 15h
    
    mov ah , 2ch ; get system time
    int 21h      ; CH = hours CL = minutes DH=seconds DL=1/100s microseconds
    xor ax , ax
    mov al , dl  ; microseconds ; save system time for later
      
    cmp al , 50
    jle le50    ; if dl less equal 50 
    sub al , 50 ; substract 50 to get random row value
    le50:
    cmp al , 24 ; row range 0 - 24 , where 24 is reserved for status text
    jl le25
    sub al , 26
    le25:
   
    mov row , al
    
    pop cx
    mov bx , cx
    mov star_row[bx] , al
    
    ; assign random color to star at cx
    mov al , dl          ; dl 1/100 sec from system time
    mov ah , 00h
    mov bx , 03h
    div bl              ; al = quotient ah = reminder (0-2)
    mov bx , cx
    
    ; 0 - red , 1 - blue , 2 - green
    cmp ah , 00h 
    jne save_color
    mov ah , 04h    ; red color has 04h value , blue 01h , green 02h 
    
    save_color:
    mov star_clr[bx] , ah
    
    inc cx 
    cmp cx , word ptr star_count
    jne next_c
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
GenerateStars ENDP
;=====================================================================
UpdateSnake PROC
; Update snake coordinates data after key press
    xor cx , cx
    mov cx , 01h
    xor si , si
    
    ; update tail
    mov dh , snake_row[si]
    mov dl , snake_col[si] 
    mov tail_dh , dh
    mov tail_dl , dl  
    
    Update:
    mov si , cx
    mov dh , snake_row[si]
    mov dl , snake_col[si]
    
    dec si
    cmp si , snake_len
    je ExitUpdate
    mov snake_row[si] , dh
    mov snake_col[si] , dl
    
    inc cx
    cmp cx , snake_len
    jne Update
    
    ExitUpdate:
    
    ; update head
    mov dh , head_dh
    mov dl , head_dl
    
    mov snake_row[snake_len - 1] , dh
    mov snake_col[snake_len - 1] , dl
    
    xor cx , cx
    
    ret
UpdateSnake ENDP
;=====================================================================
DrawSnake PROC
; Draws snake
;
; Set cursor position
; int 10h
; AH = 02h  BH = Page Number, DH = Row, DL = Column < !!

; Write character and attribute at cursor position 
; int 10h
; AH = 09h  AL = Character, BH = Page Number, BL = Color,
; CX = Number of times to print character
    xor cx , cx
    xor si , si
    mov al , SPACE_CHR  ; space - char
    mov bh , 00h
    
    DrawLoop: ; draw snake
    mov si , cx
    mov dh , snake_row[si]
    mov dl , snake_col[si]
     
    mov ah , 02h    ; set position
    int 10h
    
    mov ah , 09h    ; draw char
    push cx
    mov cx , 01h
    mov bl , color
    int 10h
    pop cx
    
    inc cx
    cmp cx , snake_len
    jne DrawLoop
    
    cmp is_snake_visible , 10
    je erase_tail
    inc is_snake_visible
    cmp is_snake_visible , 10
    jl head_update
    
    ; erase previous tail 
    erase_tail:
    mov dh , tail_dh
    mov dl , tail_dl
    mov ah , 02h    ; set position
    int 10h
    mov ah , 09h    ; draw char
    mov cx , 01h
    mov bl , 00h
    int 10h
    
    ; set cursor to head postion and change color to snake color
    head_update:
    mov dh , snake_row[snake_len - 1]
    mov dl , snake_col[snake_len - 1]
    mov ah , 02h    ; set position
    mov bl , color
    int 10h
    
    xor cx , cx
    ret    
DrawSnake ENDP
;=====================================================================
DrawStars PROC
; Draws stars according to their position saved in star_row & star_col
    push ax
    push bx
    push cx
    push dx
  
    xor cx , cx
    DrawStarsLoop:
    mov bx , cx 
    mov dh , star_row[bx]
    mov dl , star_col[bx]
    
    mov ah , 02h    ; set position
    int 10h
    
    mov ah , star_clr[bx] ; change color
    mov bl , ah
    
    mov ah , 09h    ; draw char
    mov al , "*"
    
    push cx
    mov cx , 01h
    
    int 10h
    pop cx
    
    mov bx , word ptr star_count
    inc cx 
    cmp cx , bx
    jl DrawStarsLoop
    
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
DrawStars ENDP
;=====================================================================
CheckStarAt PROC
; Checks if there is a star at head coordinates. If there is remove it from 
; star list and shift array left by 1 position
    push ax
    push bx
    push cx
    push dx
    
    xor cx , cx
    xor si , si
    
    is_there_star:
    mov si , cx
    
    mov ah , head_dh
    mov al , head_dl
    
    cmp star_row[si] , ah
    jne next_star
    cmp star_col[si] , al
    jne next_star
    jmp found_star
    
    found_star:
    mov dl , al     ; save cords
    mov dh , ah

    ; decrease #delay based on star color
    mov ax , delay
    xor bx , bx
    mov bl , star_clr[si]
    
    ; new delay calculation
    cmp bl , r_star
    jne b_clr
    mov bx , r_interval
    jmp new_delay
    
    b_clr:
    cmp bl , b_star
    jne g_clr
    mov bx , b_interval
    jmp new_delay
    
    g_clr:
    cmp bl , g_star
    jne new_delay
    mov bx , g_interval
    
    new_delay: ; updated (decreased) delay
    sub ax , bx
    mov delay , ax
    
    ; draw empty space
    mov ah , 02h    ; set position
    int 10h
    
    mov ah , 09h    ; draw empty space
    mov al , SPACE_CHR
    mov cx , 01h
    mov bl , 00h
    int 10h
    
    dec star_count  ; decrement star counter
    xor cx , cx
    mov cx , word ptr star_count
    cmp cx , 0 
    jz Exit_win
    
    move_stars_left: ; shift coordinates array left
    inc si  
    mov ah , star_row[si]
    mov al , star_col[si]
    mov bl , star_clr[si] ;shift color array
    dec si
    mov star_row[si] , ah
    mov star_col[si] , al
    mov star_clr[si] , bl ;shift color array
    
    inc si 
    
    cmp si , word ptr star_count
    jle move_stars_left
    jmp exit_check_star_at
    
    next_star:
    inc cx 
    cmp cx , word ptr star_count
    jne is_there_star

    exit_check_star_at:
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
CheckStarAt ENDP
;=====================================================================
ClrScr PROC
; Clear screen and reset cursor to 0,0
    mov ah , 02h
    mov bh , 00h
    xor dx , dx
    int 10h

    mov dl , 20h
    mov cx , 4000
    whole_screen:    
        mov ah , 02h
        int 21h
        loop whole_screen
        
    mov ah , 02h
    mov bh , 00h
    xor dx , dx
    int 10h

    ret
ClrScr ENDP
;=====================================================================
;-----------------------------;
;   END OF PROCEDURES         ;
;-----------------------------;

CODE ENDS
;-----------------------------;
;   END OF CODE SEGEMENT      ;
;-----------------------------;

END Main