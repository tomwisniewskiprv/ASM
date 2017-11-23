;Operacje blokowe

%TITLE "Operacje Blokowe"
    .8086
    .MODEL small
MAINSTACK SEGMENT STACK 
    dw 1024 dup(?) 
    sptr label word
MAINSTACK ENDS

DATA SEGMENT
    row    dw 0
    buffer dw 80 dup ("=")
DATA ENDS

; ==============================================================================
;   CODE
; ==============================================================================
CODE SEGMENT
    assume cs:code , ds:data 
MAIN PROC
    ; laduje segmenty danych
    mov ax , data
    mov ds , ax
    mov es , ax
    
    call RandomData ; zapelnia pamiec wartosciami liter od A do .. rzedami
                    ; wywo?a? tylko raz
    
    mov cx , 0
    MainLoop:     
    push cx             ; zapamietuje licznik petli
    
    call Delay          ; dla efektu graficznego
    call RandomRow      ; wybiera losowy rzad
    call ReadRow        ; czyta i zapisuje go do buffora
    call WriteX         ; zapelnia rzad wybranym znakiem
    call Delay          ; opoznienie
    call WriteRow       ; zapisuje do pamieci z buffora poprzednio zapamietany rzad
    
    pop cx              ; odczytuje i inkrementuje licznik petli
    inc cx
    cmp cx , 10         ; wykona si? 10 razy
    jne MainLoop
    
Exit:
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
; ==============================================================================
;   PROCEDURES
; ==============================================================================
WriteRow proc
    mov ax , data   ; zrodlo source
    mov ds , ax 
    lea si , buffer ; przesuniecie

    mov ax , 0b800h ; cel
    mov es , ax
    mov ax , row
    mov bx , 160
    mul bx
    
    mov di , ax     ; rzad row
    mov cx , 80     ; 80 slow
    cld    
    rep movsw
    
    ret
WriteRow endp


WriteX proc
; ES: DI DESTINATION
; 0b800h:0000   pocz?tek pami?ci trybu tekstowego    
    mov ax , 0b800h
    mov es , ax
    
    mov ax , data
    mov ds , ax
    mov ax , row
    mov bx , 160
    mul bx
    
    mov di , ax
    mov cx , 80     ; dlugosc lini 80 slow
    mov ah , 07h    ; kolor tla i czcionki
    mov al , "-"    ; znak
    cld             ; kopiuje do przodu
    rep stosw
    
    ret
WriteX endp

RandomRow proc
; losowa z zakresu 0 - 24 ?!
    xor ax , ax
    mov ah , 2ch ; get system time
    int 21h      ; CH = hours CL = minutes DH=seconds DL=1/100s microseconds

    mov al , dl  ; microseconds ;
    cmp al , 50
    jl l50
    sub al , 50
    
    l50:
    cmp al , 25
    jl randomdone
    sub al , 25
    
    randomdone:
    mov ah , 0
    mov row , ax
    
    ret
RandomRow endp

Delay proc
; Delay 2 seconds
    mov cx , 01Eh
    mov dx , 8480h
    mov ah , 86h ; delay
    mov al , 00h
    int 15h
    ret
Delay endp


ReadRow proc
; DS: SI SOURCE
; ES: DI DESTINATION
; 0b800h:0000   pocz?tek pami?ci trybu tekstowego

    mov ax , data
    mov ds , ax
    mov bx , row
    
    mov ax , 0b800h
    mov ds , ax
    mov ax , bx         ; row * 160 , kolejne wiersze
    mov bx , 160        ; dwa bajty na 1 slowo na pozycji
    mul bx
    mov si , ax
    
    mov ax , data
    mov es , ax
    lea di , buffer 
    
    mov cx , 80         ; 80 znakow / reprezentacja danych to slowo nie baj
    cld
    rep movsw

    ret
ReadRow endp 

RandomData proc
; random data

    mov dl , 65
    mov ah , 02h
    
    mov cx , 24
    writeline:
    push cx
    mov cx , 80
    writechar:
        int 21h
    loop writechar
    inc dl
    pop cx 
    loop writeline
    
    ret
RandomData endp
; ==============================================================================
;    CODE END
; ==============================================================================
CODE ENDS
END MAIN