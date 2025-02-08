# diegOS

Un sistema operativo echo desde 0, construido en 16 bits, solo texto, no busca ser nada, es solo un proyecto para saber como funcionan los sistemas operativos por dentro.

Este SO estaba pensado para ser modular, de forma que puedas añadir un modulo para ejecutar codigo C

# Sistema de archivos

Todo comienza en BIOS, es como el root, si vas a la izquierda (\BIOS) te sales a cosas que estan fuera de la pc, como puede ser un disco duro externo, por ejemplo el disco duro externo llamado "Expansion" estaria ubicado en la carpeta \Expansion\disk\local\BIOS es raro, ya se


BIOS/

/conf {Configuraciones del sistema}

/disk {discos internos para todos}

/data {datos e informacion del sistema}

/usr {directorio con los usuarios}

/usr/gdata {no es un usuario pero son datos generales para todos los usuarios, como programas que pueden usar todos, configuraciones, cosas publicas...}

/usr/{nombre}/ {aqui estan las cosas referentes a ese usuario}

/usr/{nombre}/home {esta es la home del usuario, aqui se encuentran las carpetas de descargas, imagenes, documebntos, videos, musica, etc...}

/usr/{nombre}/conf {aqui se almacenan configuraciones, logs e historiales del usuario}

/usr/{nombre}/prog {aqui se almacenan los programas del usuario}

/usr/{nombre}/var {aqui se almacenan las variables, estadisticas, entradas para el administrador de tareas programadas...}

/usr/{nombre}/utemp {aqui se almacenan los datos y cosas temporales del usuario}

/usr/{nombre}/udisk {discos internos solo para ese usuario}

/utl {utilidades como el shel y programas esenciales}

/cut {para absolutamente nada, es solo para pruevas de desarroyo y no deberia usarse para nada}

/tmp {archivos temporales de todo menos de un usuario}

/emi {son cosas que van a ser emitidas al exterior, como archivos de un ftp o informacion}


\BIOS

local\ {dispositivos de entrada o salida a los que se accede por cable de datos, como un usb, una impresora o un teclado}

cloud\ {ubicaciones a las que se accede a traves de red, como una carpeta compartida, servidores ftp...}

extemp\ {configuraciones y datos temporales referentes a ubicaciones externas (todo lo anterior)}

exconf\ {configuraciones importantes de dispositivos y cosas externas (todo lo anterior)}


no te lo tomes enserio, es solo que me distraje de hacer tarea.

#Requisitos para usar build.sh:

nasm

dd (ya viene en el paquete coreutils)

stat (ya viene en el paquete coreutils)

genisoimage (para build.sh)

xorriso (para xbuild.sh)

qemu (opcional, al finalizar la compilacion se ejecutara una maquina virtual)
