; las funciones de mostrar texto son comunes en el bootloader y en el kernel, por lo que las he metido aqui, tanto el bootloader como el kernel necesitan poder acceder a este archivo para mostrar el sistema
print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

print_newline:
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    ret