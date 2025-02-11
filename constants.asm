; constantes del sistema
MAX_CMD_LENGTH    equ 255    ; longitud maxima de comando
MAX_PATH_LENGTH   equ 256    ; longitud maxima de ruta
MAX_NAME_LENGTH   equ 32     ; longitud maxima de nombre de archivo
MAX_DIRS         equ 256    ; maximo numero de directorios (aumentado desde la ultima vez, por recomendacion de el)
MAX_FILES        equ 512    ; maximo numero de archivos (aumentado desdebla ultima vez)
MAX_USERS        equ 16     ; maximo numero de usuarios

; codigos de error
ERR_NOT_FOUND    equ 1      ; archivo/directorio no encontrado
ERR_EXISTS       equ 2      ; ya existe
ERR_INVALID      equ 3      ; nombre/ruta invalida
ERR_FULL         equ 4      ; sistema lleno
ERR_PERM         equ 5      ; error de permisos
ERR_USER_LIMIT   equ 6      ; limite de usuarios alcanzado
ERR_LOGIN        equ 7      ; error de login

; flags de archivos
FLAG_DIR         equ 1      ; es directorio
FLAG_FILE        equ 2      ; es archivo
FLAG_SYSTEM      equ 4      ; archivo de sistema
FLAG_HIDDEN      equ 8      ; archivo oculto
FLAG_USER        equ 16     ; pertenece a un usuario
FLAG_EXTERNAL    equ 32     ; ubicacion externa (local/cloud)

; constantes de usuarios
MAX_USERS       equ 16     ; maximo numero de usuarios
PRIV_USER       equ 1      ; usuario normal
PRIV_ADMIN      equ 2      ; administrador

; permisos de archivos
PERM_READ       equ 4      ; permiso de lectura
PERM_WRITE      equ 2      ; permiso de escritura
PERM_EXEC       equ 1      ; permiso de ejecucion

; privilegios de usuario
PRIV_USER       equ 1      ; usuario normal
PRIV_ADMIN      equ 2      ; administrador
