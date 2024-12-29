; Constantes del sistema
MAX_CMD_LENGTH    equ 255    ; Longitud máxima de comando
MAX_PATH_LENGTH   equ 256    ; Longitud máxima de ruta
MAX_NAME_LENGTH   equ 32     ; Longitud máxima de nombre de archivo
MAX_DIRS         equ 256    ; Máximo número de directorios (aumentado)
MAX_FILES        equ 512    ; Máximo número de archivos (aumentado)
MAX_USERS        equ 16     ; Máximo número de usuarios

; Códigos de error
ERR_NOT_FOUND    equ 1      ; Archivo/directorio no encontrado
ERR_EXISTS       equ 2      ; Ya existe
ERR_INVALID      equ 3      ; Nombre/ruta inválida
ERR_FULL         equ 4      ; Sistema lleno
ERR_PERM         equ 5      ; Error de permisos
ERR_USER_LIMIT   equ 6      ; Límite de usuarios alcanzado
ERR_LOGIN        equ 7      ; Error de login

; Flags de archivos
FLAG_DIR         equ 1      ; Es directorio
FLAG_FILE        equ 2      ; Es archivo
FLAG_SYSTEM      equ 4      ; Archivo de sistema
FLAG_HIDDEN      equ 8      ; Archivo oculto
FLAG_USER        equ 16     ; Pertenece a un usuario
FLAG_EXTERNAL    equ 32     ; Ubicación externa (local/cloud)

; Constantes de usuarios
MAX_USERS       equ 16     ; Máximo número de usuarios
PRIV_USER       equ 1      ; Usuario normal
PRIV_ADMIN      equ 2      ; Administrador

; Permisos de archivos
PERM_READ       equ 4      ; Permiso de lectura
PERM_WRITE      equ 2      ; Permiso de escritura
PERM_EXEC       equ 1      ; Permiso de ejecución

; Privilegios de usuario
PRIV_USER       equ 1      ; Usuario normal
PRIV_ADMIN      equ 2      ; Administrador