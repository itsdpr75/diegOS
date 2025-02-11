bits 16
org 0x1000

%include "constants.asm"   ; archivo de constantes del sistema
%include "filesystem.asm"  ; archivo del sistema de archivos
%include "users.asm"       ; archivo para los usuarios
%include "terminal.asm"    ; archivo para la terminal y los procesos
%include "bootloader.asm"  ; no deberia ponerlo, pero creo que sin esto no funciona
%include "lib.asm"         ; archivo compartido para el kernel y el bootloader

start:
    ; configurar segmentos
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0xFFF0      ; establecer stack, (es la memoria temporal para las funciones y datos locales)

    ; limpiar pantalla
    mov ah, 0x00        ; funcion para establecer modo de video
    mov al, 0x03        ; modo texto 80x25 color
    int 0x10
    
    ; inicializar componentes del sistema
    call fs_init        ; sistema de archivos
    call users_init     ; sistema de usuarios
    call terminal_init  ; terminal

    ; mostrar mensaje de bienvenida
    mov si, welcome_msg
    call print_string

    ; entrar en el bucle principal, literalmente es un salto?
    jmp kernel_loop

; bucle principal del kernel
kernel_loop:
    ; mostrar prompt
    mov si, prompt
    call print_string
    
    ; obtener comando
    mov di, command_buffer
    call read_string
    
    ; procesar comando
    mov si, command_buffer
    call process_command
    
    jmp kernel_loop

; funcion para leer una cadena
read_string:
    xor cx, cx          ; contador de caracteres
.loop:
    mov ah, 0x00        ; esperar tecla
    int 0x16
    
    cmp al, 0x0D        ; accion enter
    je .done
    
    cmp al, 0x08        ; accion borrar
    je .backspace
    
    cmp cx, MAX_CMD_LENGTH
    je .loop
    
    stosb               ; guardar caracter
    inc cx
    
    mov ah, 0x0E        ; eco del caracter ???
    int 0x10
    
    jmp .loop

.backspace:
    test cx, cx         ; buffer vacio
    jz .loop
    
    dec di              ; retroceder puntero
    dec cx
    
    mov ah, 0x0E        ; borrar caracter
    mov al, 0x08
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 0x08
    int 0x10
    
    jmp .loop

.done:
    mov al, 0           ; terminar cadena
    stosb
    
    mov ah, 0x0E        ; nueva linea
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    ret

; variables y datos
section .data
    welcome_msg db 13, 10, "diegOS v0.4 - Sistema Operativo iniciado - Bienvenido", 13, 10, 13, 10, 0
    prompt db "diegOS-> ", 0
    command_buffer times 256 db 0
