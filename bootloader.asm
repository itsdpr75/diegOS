bits 16
org 0x7C00

start:
    ; configuracion del video, creo que es para el modo texto, luego miro
    mov ah, 0x02        ; funcion: mover la linea esa
    mov bh, 0x00        ; la pagina del video
    mov dh, 0x00        ; fila 0
    mov dl, 0x00        ; columna 0
    int 0x10            ; llamar a la interrupción de video

    ; mensajes de carga, recuerda que los mensajes estan mas abajo
    call print_msg1
    call wait_0_5s

    call print_loading_kernel
    call wait_5s

    call print_checking_status
    call wait_0_8s

    call print_kernel_ok
    call wait_10s

    call print_fs_ok
    call wait_2s

    call print_memory_ok
    call wait_3s

    call print_starting
    ; Cargar y ejecutar el kernel
    call load_kernel
    jmp $

; estas son las funciones de los mensajes de carga
print_msg1:
    mov si, msg1
    call print_string
    ret

print_loading_kernel:
    mov si, loading_kernel
    call print_string
    ret

print_checking_status:
    mov si, checking_status
    call print_string
    ret

print_kernel_ok:
    mov si, kernel_ok
    call print_string
    ret

print_fs_ok:
    mov si, fs_ok
    call print_string
    ret

print_memory_ok:
    mov si, memory_ok
    call print_string
    ret

print_starting:
    mov si, starting
    call print_string
    ret

; eso es lo que imprime la cadena
print_string:
    lodsb               ; esto carga el caracter
    cmp al, 0
    je .done            ; en caso de que sea nulo termina, que puede ser nulo? ni puta idea solo se que funciona
    mov ah, 0x0E        ; esto es la funcion de imprimir el caracter
    int 0x10
    jmp print_string
.done:
    ret

; esto carga el kernel
load_kernel:
    mov bx, 0x1000      ; direccion de carga de memoria 0x1000
    mov ah, 0x02        ; funcion: leer sectores
    mov al, 4           ; numero de sectores a leer
    mov ch, 0x00        ; cilindro 0, no me preguntes, estaba en la pagina esa
    mov cl, 0x02        ; sector 2 (el kernel comienza aqui)
    mov dh, 0x00        ; cabeza 0, esto es lo mismo, se que funciona, pero no que hace
    mov dl, 0x00        ; primer disco (floppy/CD)
    int 0x13            ; llamar a la interrupcion de disco
    ret

; funciones de espera (son simples bucles, el tiempo no es real por que dependen del ciclo del procesador)
wait_0_5s:
    mov cx, 30000
    call delay
    ret

wait_5s:
    mov cx, 300000
    call delay
    ret

wait_0_8s:
    mov cx, 48000
    call delay
    ret

wait_10s:
    mov cx, 600000
    call delay
    ret

wait_2s:
    mov cx, 120000
    call delay
    ret

wait_3s:
    mov cx, 180000
    call delay
    ret

; esto es la funcion de las esperas
delay:
    push cx
.loop:
    nop                 ; no hace nada :>
    loop .loop
    pop cx
    ret

; mensajes, aqui si puedes cvambiar esto
msg1 db "Cargador de arranque limm16 trabajando.", 0
loading_kernel db "Cargando kernel LUX...", 0
checking_status db "Comprobando estado...", 0
kernel_ok db "Kernel {OK}", 0
fs_ok db "Sistema de archivos {OK}", 0
memory_ok db "Memoria {OK}", 0
starting db "Iniciando...", 0

times 510-($-$$) db 0
dw 0xAA55
