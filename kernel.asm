bits 16
org 0x1000

start:
    ; Configurar segmentos
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0xFFF0      ; Establecer stack

    ; Limpiar pantalla
    mov ah, 0x00        ; función para establecer modo de video
    mov al, 0x03        ; modo texto 80x25 color
    int 0x10
    
    ; Inicializar el sistema
    call fs_init        ; Inicializar sistema de archivos
    call users_init     ; Inicializar sistema de usuarios
    call terminal_init  ; Inicializar terminal

    ; Mostrar mensaje de bienvenida
    mov si, welcome_msg
    call print_string

    ; Entrar en el bucle principal
    jmp kernel_loop

; Bucle principal del kernel
kernel_loop:
    ; Mostrar prompt
    mov si, prompt
    call print_string
    
    ; Obtener comando
    mov di, command_buffer
    call read_string
    
    ; Procesar comando
    mov si, command_buffer
    call process_command
    
    jmp kernel_loop

; Función para leer una cadena
read_string:
    xor cx, cx          ; Contador de caracteres
.loop:
    mov ah, 0x00        ; Esperar tecla
    int 0x16
    
    cmp al, 0x0D        ; ¿Enter?
    je .done
    
    cmp al, 0x08        ; ¿Retroceso?
    je .backspace
    
    cmp cx, MAX_CMD_LENGTH
    je .loop
    
    stosb               ; Guardar caracter
    inc cx
    
    mov ah, 0x0E        ; Eco del caracter
    int 0x10
    
    jmp .loop

.backspace:
    test cx, cx         ; ¿Buffer vacío?
    jz .loop
    
    dec di              ; Retroceder puntero
    dec cx
    
    mov ah, 0x0E        ; Borrar caracter
    mov al, 0x08
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 0x08
    int 0x10
    
    jmp .loop

.done:
    mov al, 0           ; Terminar cadena
    stosb
    
    mov ah, 0x0E        ; Nueva línea
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    ret

; Variables y datos
section .data
    welcome_msg db 13, 10, "diegOS v0.1 - Sistema Operativo iniciado", 13, 10, 13, 10, 0
    prompt db "diegOS> ", 0
    command_buffer times 256 db 0