; Estructura del sistema de archivos
struc fs_entry
    .name:      resb MAX_NAME_LENGTH
    .parent:    resw 1    ; Índice del directorio padre
    .flags:     resb 1    ; Tipo y atributos
    .size:      resd 1    ; Tamaño en bytes
    .data:      resd 1    ; Puntero a los datos
endstruc

section .data
    current_dir      dw 0        ; Directorio actual
    fs_entries      times (MAX_DIRS + MAX_FILES) * fs_entry_size db 0
    next_free_entry dw 0

    ; Nombres de directorios básicos
    dir_bios    db "BIOS", 0
    dir_conf    db "conf", 0
    dir_disk    db "disk", 0
    dir_data    db "data", 0
    dir_usr     db "usr", 0
    dir_gdata   db "gdata", 0
    dir_utl     db "utl", 0
    dir_cut     db "cut", 0
    dir_tmp     db "tmp", 0
    dir_emi     db "emi", 0
    
    ; Directorios de usuario
    dir_home    db "home", 0
    dir_uconf   db "conf", 0
    dir_prog    db "prog", 0
    dir_var     db "var", 0
    dir_utemp   db "utemp", 0
    dir_udisk   db "udisk", 0
    
    ; Directorios externos
    dir_ext_local  db "local", 0
    dir_ext_cloud  db "cloud", 0
    dir_ext_temp   db "extemp", 0
    dir_ext_conf   db "exconf", 0
    
    ; Subdirectorios de home
    dir_downloads  db "downloads", 0
    dir_documents  db "documents", 0
    dir_pictures   db "pictures", 0
    dir_music     db "music", 0
    dir_videos    db "videos", 0

section .text

; Inicializar sistema de archivos
fs_init:
    push ax
    push si
    push di
    
    ; Crear directorio raíz BIOS
    mov si, dir_bios
    xor ax, ax          ; Sin padre (raíz)
    mov bl, FLAG_DIR | FLAG_SYSTEM
    call fs_create_dir
    mov [root_dir], ax  ; Guardar índice del directorio raíz
    
    ; Crear estructura básica en BIOS/
    push word [root_dir]
    pop ax              ; AX = índice de BIOS
    
    mov si, dir_conf
    call fs_create_dir
    
    mov si, dir_disk
    call fs_create_dir
    
    mov si, dir_data
    call fs_create_dir
    
    mov si, dir_usr
    call fs_create_dir
    mov [usr_dir], ax   ; Guardar índice de /usr
    
    mov si, dir_utl
    call fs_create_dir
    
    mov si, dir_cut
    call fs_create_dir
    
    mov si, dir_tmp
    call fs_create_dir
    
    mov si, dir_emi
    call fs_create_dir
    
    ; Crear /usr/gdata
    push word [usr_dir]
    pop ax
    mov si, dir_gdata
    call fs_create_dir
    
    ; Crear estructura externa (\BIOS)
    mov si, dir_ext_local
    xor ax, ax          ; Raíz externa
    mov bl, FLAG_DIR | FLAG_EXTERNAL
    call fs_create_dir
    
    mov si, dir_ext_cloud
    call fs_create_dir
    
    mov si, dir_ext_temp
    call fs_create_dir
    
    mov si, dir_ext_conf
    call fs_create_dir
    
    pop di
    pop si
    pop ax
    ret

; Crear directorio de usuario
; SI = nombre de usuario
create_user_dirs:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; Guardar nombre de usuario
    mov di, temp_buffer
    call strcpy
    
    ; Crear directorio de usuario en /usr
    mov si, temp_buffer
    push word [usr_dir]
    pop ax
    mov bl, FLAG_DIR | FLAG_USER
    call fs_create_dir
    mov dx, ax          ; DX = índice del directorio de usuario
    
    ; Crear subdirectorios del usuario
    push dx
    pop ax
    
    mov si, dir_home
    call fs_create_dir
    push ax             ; Guardar índice de home
    
    mov si, dir_uconf
    call fs_create_dir
    
    mov si, dir_prog
    call fs_create_dir
    
    mov si, dir_var
    call fs_create_dir
    
    mov si, dir_utemp
    call fs_create_dir
    
    mov si, dir_udisk
    call fs_create_dir
    
    ; Crear subdirectorios en home
    pop ax              ; Recuperar índice de home
    
    mov si, dir_downloads
    call fs_create_dir
    
    mov si, dir_documents
    call fs_create_dir
    
    mov si, dir_pictures
    call fs_create_dir
    
    mov si, dir_music
    call fs_create_dir
    
    mov si, dir_videos
    call fs_create_dir
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

section .bss
    root_dir    resw 1   ; Índice del directorio raíz
    usr_dir     resw 1   ; Índice del directorio /usr
    temp_buffer resb MAX_PATH_LENGTH

;esto nisiquiera esta completo
