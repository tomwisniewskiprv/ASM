;worksheet  1
;exercise   2

segment code
assume cs: code

main:
    mov bx , 0ah     ; char counter
    mov cx , bx     ;
    mov dl , 41h    ; ascii value to display

next_char:          ; displays next char
    mov ah , 02h
    int 21h
    inc dl
    dec cx
    jnz next_char

exit:    
    mov ah, 4ch
    int 21h

ends code   ;end of code segment
end main    ;end of program and starting point

