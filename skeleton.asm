;asm skeleton

;worksheet  1
;exercise   1

.MODEL SMALL
.DATA
.CODE
main PROC

exit:
    mov ah , 4Ch
    int 21h
main ENDP

.STACK 128

end main