; Estructura de usuario
struc user
    .username:   resb MAX_NAME_LENGTH
    .password:   resb 32        ; Hash simple de la contraseña
    .home_dir:   resw 1        ; Índice del directorio home
    .privileges: resb 1        ; Privilegios del usuario
endstruc

section .data
    current_user     dw -1     ; Usuario actual (-1 = no logueado)
    users_list       times MAX_USERS * user_size db 0
    users_count      dw 0
    
    ; Usuario root predeterminado
    root_user   db "root", 0
    root_pass   db "admin123", 0  ; En un sistema real, esto sería un hash, aclaro que ahora mismo paso de complicarme la vida mas de lo que ya lo estoy haciendo por no usar c o cualquier otra cosa :>
    
    ; Mensajes del sistema de usuarios
    msg_login_prompt db "Usuario: ", 0
    msg_pass_prompt  db "Contraseña: ", 0
    msg_login_fail   db "Error de login", 0x0D, 0x0A, 0
    msg_login_ok     db "Bienvenido, ", 0

section .text

; Inicializar sistema de usuarios
users_init:
    push ax
    push si
    
    ; Crear usuario root
    mov si, root_user
    mov di, root_pass
    mov bl, PRIV_ADMIN
    call create_user
    
    pop si
    pop ax
    ret

; Crear usuario
; SI = nombre, DI = contraseña, BL = privilegios
create_user:
    push ax
    push bx
    push cx
    push si
    push di
    
    mov ax, [users_count]
    cmp ax, MAX_USERS
    jae .error
    
    ; Calcular offset en la lista de usuarios
    mov cx, user_size
    mul cx
    mov di, users_list
    add di, ax
    
    ; Copiar nombre
    mov cx, MAX_NAME_LENGTH
.copy_name:
    lodsb
    stosb
    test al, al
    jz .name_done
    loop .copy_name
.name_done:

    ; Crear directorio home
    ; TODO: Implementar creación de directorio home
    
    ; Guardar privilegios
    mov [di + user.privileges], bl
    
    inc word [users_count]
    
.done:
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
    
.error:
    mov si, err_user_limit
    call print_string
    jmp .done

; Login de usuario
user_login:
    push ax
    push si
    push di
    
    ; Pedir nombre
    mov si, msg_login_prompt
    call print_string
    
    mov di, temp_buffer
    call read_string
    
    ; Buscar usuario
    mov si, temp_buffer
    call find_user
    cmp ax, -1
    je .fail
    
    ; Pedir contraseña
    mov si, msg_pass_prompt
    call print_string
    
    mov di, temp_buffer
    call read_string_hidden  ; No muestra la contraseña
    
    ; Verificar contraseña
    ; TODO: Implementar verificación real de contraseña
    
    ; Login exitoso
    mov [current_user], ax
    
    mov si, msg_login_ok
    call print_string
    
    mov si, temp_buffer
    call print_string
    call print_newline
    
.done:
    pop di
    pop si
    pop ax
    ret
    
.fail:
    mov si, msg_login_fail
    call print_string
    jmp .done

section .bss
    temp_buffer: resb 256

;todavia me faltan cosas por hacer aqui :/, me las he dejado apuntadas con un todo, como aquel tio, espero no olvidarlo
