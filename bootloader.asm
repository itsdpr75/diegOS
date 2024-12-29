bits 16
org 0x7C00

start:
    ; Inicializar segmentos
    cli                 ; Deshabilitar interrupciones durante la configuración
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti                 ; Rehabilitar interrupciones

    ; Guardar disco de arranque
    mov [boot_drive], dl

    ; Restablecer disco
    xor ah, ah
    mov dl, [boot_drive]
    int 0x13
    jc disk_error

    ; Cargar kernel
    mov si, loading_msg
    call print_string

    ; Configurar carga
    mov ax, 0x1000      ; Segmento destino
    mov es, ax
    xor bx, bx          ; Offset destino

    ; Parámetros de lectura
    mov ah, 0x02        ; Función de lectura
    mov al, 63          ; Número de sectores (máximo por operación)
    mov ch, 0           ; Cilindro 0
    mov cl, 2           ; Empezar desde sector 2
    mov dh, 0           ; Cabeza 0
    mov dl, [boot_drive]; Disco de arranque

    ; Intentar leer
    int 0x13
    jc disk_error

    ; Verificar que se cargó correctamente
    mov si, success_msg
    call print_string

    ; Saltar al kernel
    mov si, jump_msg
    call print_string
    
    cli                 ; Deshabilitar interrupciones para el salto
    jmp 0x1000:0000    ; Salto lejano al kernel

disk_error:
    mov si, error_msg
    call print_string
    xor ah, ah
    int 0x16            ; Esperar tecla
    int 0x19            ; Reiniciar

; Función para imprimir cadena
print_string:
    lodsb               ; Cargar siguiente carácter
    or al, al           ; ¿Es cero?
    jz .done
    mov ah, 0x0E        ; Función de teletipo
    mov bx, 0x0007      ; Página 0, color gris
    int 0x10            ; Llamada a BIOS
    jmp print_string
.done:
    ret

; Datos
boot_drive  db 0
loading_msg db "Cargando kernel...", 13, 10, 0
error_msg   db "Error al cargar el kernel!", 13, 10, 0
success_msg db "Kernel cargado correctamente", 13, 10, 0
jump_msg    db "Saltando al kernel...", 13, 10, 0

times 510-($-$$) db 0   ; Rellenar hasta 510 bytes
dw 0xAA55               ; Firma de arranque