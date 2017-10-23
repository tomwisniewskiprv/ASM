;worksheet  1
;exercise   1


segment code
assume cs: code

main:
    mov dl , 02ah    ; ascii for '*'
    mov ah , 02h
    int 21h

exit:  
    mov ah, 4ch
    int 21h

ends code   ;end of code segment
end main    ;end of program and execution point

