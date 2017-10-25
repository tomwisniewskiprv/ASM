;asm skeleton v2

;worksheet  1
;exercise   1

%TITLE "SKELETON"
    .8086
    .MODEL small
    .STACK 256
    .DATA

    .CODE
MAIN PROC

Exit:
    mov ah , 4Ch
    int 21h
    
MAIN ENDP
END MAIN