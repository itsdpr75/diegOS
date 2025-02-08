section .data
    ; Tabla de comandos extendida
    cmd_table:
        dw cmd_help, cmd_help_str
        dw cmd_cd, cmd_cd_str
        dw cmd_ls, cmd_ls_str
        dw cmd_init0, cmd_init0_str
        dw cmd_mkdir, cmd_mkdir_str
        dw cmd_rm, cmd_rm_str
        dw cmd_cp, cmd_cp_str
        dw cmd_mv, cmd_mv_str
        dw cmd_cat, cmd_cat_str
        dw cmd_login, cmd_login_str
        dw cmd_logout, cmd_logout_str
        dw cmd_adduser, cmd_adduser_str
        dw cmd_whoami, cmd_whoami_str
        dw 0  ; Fin de tabla

    ; Strings de comandos
    cmd_mkdir_str   db "mkdir", 0
    cmd_rm_str      db "rm", 0
    cmd_cp_str      db "cp", 0
    cmd_mv_str      db "mv", 0
    cmd_cat_str     db "cat", 0
    cmd_login_str   db "login", 0
    cmd_logout_str  db "logout", 0
    cmd_adduser_str db "adduser", 0
    cmd_whoami_str  db "whoami", 0
    
    ; Mensajes de error
    err_perm   db "Error: Permiso denegado", 0x0D, 0x0A, 0
    err_syntax db "Error: Sintaxis incorrecta", 0x0D, 0x0A, 0

section .text

; Nuevos comandos implementados
cmd_mkdir:
    ; Requiere argumento
    call get_arg
    test ax, ax
    jz .syntax_error
    
    ; Verificar permisos
    call check_write_perm
    test ax, ax
    jz .perm_error
    
    ; Crear directorio
    mov si, arg_buffer
    mov bl, FLAG_DIR
    call fs_create_dir
    ret
    
.syntax_error:
    mov si, err_syntax
    call print_string
    ret
    
.perm_error:
    mov si, err_perm
    call print_string
    ret

cmd_rm:
    ; Similar a mkdir pero elimina
    call get_arg
    test ax, ax
    jz .syntax_error
    
    call check_write_perm
    test ax, ax
    jz .perm_error
    
    mov si, arg_buffer
    call fs_delete
    ret

cmd_cp:
    ; Copiar archivo/directorio
    call get_arg          ; Origen
    test ax, ax
    jz .syntax_error
    
    mov si, arg_buffer
    mov di, temp_buffer
    call strcpy           ; Guardar origen
    
    call get_arg          ; Destino
    test ax, ax
    jz .syntax_error
    
    mov si, temp_buffer   ; Origen
    mov di, arg_buffer    ; Destino
    call fs_copy
    ret

cmd_mv:
    ; Similar a cp pero elimina el origen
    ; [Implementación similar a cp]
    ret

cmd_cat:
    ; Mostrar contenido de archivo
    call get_arg
    test ax, ax
    jz .syntax_error
    
    mov si, arg_buffer
    call fs_cat
    ret

cmd_login:
    call user_login
    ret

cmd_logout:
    mov word [current_user], -1
    mov si, msg_logout
    call print_string
    ret

cmd_adduser:
    ; Verificar si es admin
    call check_admin
    test ax, ax
    jz .perm_error
    
    ; Obtener nombre de usuario
    call get_arg
    test ax, ax
    jz .syntax_error
    
    ; TODO: Pedir y verificar contraseña
    
    mov si, arg_buffer
    mov di, default_pass  ; Contraseña temporal
    mov bl, PRIV_USER
    call create_user
    ret

cmd_whoami:
    mov ax, [current_user]
    cmp ax, -1
    je .not_logged
    
    ; Mostrar nombre del usuario actual
    call get_username
    call print_string
    call print_newline
    ret
    
.not_logged:
    mov si, msg_not_logged
    call print_string
    ret

; Funciones auxiliares
get_arg:
    ; Obtiene el siguiente argumento del comando
    ; Retorna AX = 1 si hay argumento, 0 si no
    ; El argumento se guarda en arg_buffer
    push si
    push di
    
    mov si, command_buffer
    call skip_word       ; Saltar el comando
    
    mov di, arg_buffer
    call get_word        ; Obtener argumento
    
    pop di
    pop si
    ret

check_write_perm:
    ; Verifica si el usuario actual tiene permisos de escritura
    ; Retorna AX = 1 si tiene permiso, 0 si no
    push bx
    
    mov ax, [current_user]
    cmp ax, -1
    je .no_perm
    
    ; TODO: Implementar verificación real de permisos
    mov ax, 1
    
.done:
    pop bx
    ret
    
.no_perm:
    xor ax, ax
    jmp .done

section .bss
    arg_buffer:  resb MAX_PATH_LENGTH
    temp_buffer: resb MAX_PATH_LENGTH
