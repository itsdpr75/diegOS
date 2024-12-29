#!/bin/bash

# Crear directorios necesarios
mkdir -p build

# Compilar bootloader
echo "Compilando bootloader..."
nasm -f bin bootloader.asm -o build/bootloader.bin || exit 1

# Compilar kernel
echo "Compilando kernel..."
nasm -f bin kernel.asm -o build/kernel.bin || exit 1

# Verificar tamaños
BOOTLOADER_SIZE=$(stat -f %z build/bootloader.bin || stat -c %s build/bootloader.bin)
KERNEL_SIZE=$(stat -f %z build/kernel.bin || stat -c %s build/kernel.bin)

echo "Tamaño del bootloader: $BOOTLOADER_SIZE bytes"
echo "Tamaño del kernel: $KERNEL_SIZE bytes"

if [ $BOOTLOADER_SIZE -gt 512 ]; then
    echo "Error: El bootloader es más grande que 512 bytes!"
    exit 1
fi

# Crear imagen de disco floppy (1.44MB)
echo "Creando imagen de disco..."
dd if=/dev/zero of=build/disk.img bs=1024 count=1440 2>/dev/null

# Escribir bootloader en el primer sector
echo "Escribiendo bootloader..."
dd if=build/bootloader.bin of=build/disk.img conv=notrunc 2>/dev/null

# Escribir kernel inmediatamente después del bootloader
echo "Escribiendo kernel..."
dd if=build/kernel.bin of=build/disk.img seek=1 conv=notrunc 2>/dev/null

# Crear ISO
echo "Creando ISO..."
mkdir -p iso/boot
cp build/disk.img iso/boot/
genisoimage -quiet -V 'DIEGOS' -o diegOS.iso -b boot/disk.img -hide boot/disk.img \
            -hide-joliet boot/disk.img -no-emul-boot -boot-load-size 4 iso/

echo "Construcción completada."
echo "Probando con QEMU..."
qemu-system-i386 -fda build/disk.img -boot a -m 128