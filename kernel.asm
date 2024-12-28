bits 16
org 0x1000

start:
    ; enseñar un mensaje
    mov si, welcome_msg
    call print_string
    jmp $

; Función para imprimir una cadena
print_string:
    lodsb               ; cargar letras
    cmp al, 0
    je .done            ; si es nulo, termina
    mov ah, 0x0E        ; funcion de imprimir las letras
    int 0x10
    jmp print_string
.done:
    ret

; mensaje de bienvenida
welcome_msg db "Bienvenido a diegOS. Nada que hacer aqui... por ahora", 0
