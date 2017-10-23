;worksheet  1
;exercise   3


segment code
assume cs: code

main:
    mov bx , 00h    ; space counter
    mov cx , 03h    ; line counter
    
next_line:
    push cx         ; remeber how many lines left
    
    mov cx , bx     ; is it first line ?
    cmp cx , 0
    je first_space
    
    next_space:
        mov dl , 20h    ; ascii space
        int 21h
        dec cx
        jnz next_space        
        
    first_space:
        mov cx , 0ah    ; char counter
        mov dl , 41h    ; ascii value to display
        
    next_char:          ; displays next char
        mov ah , 02h
        int 21h
        inc dl          ; next ascii value
        dec cx          ; one less char to display
        jnz next_char
        
    ; endline
    mov dl , 0ah        ; CR
    int 21h
    mov dl , 0dh        ; LF
    int 21h
    
    add bx , 02h    ; add two spaces
    pop cx
    dec cx          ; how many lines left ?
    cmp cx , 0
    jnz next_line
    
exit:    
    mov ah, 4ch
    int 21h

ends code   ;end of code segment
end main    ;end of program and starting point

