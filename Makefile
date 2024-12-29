# Variables
ASM=nasm
ASMFLAGS=-f bin
QEMU=qemu-system-i386
QEMUFLAGS=-boot d -cdrom diegOS.iso -m 128

# Archivos fuente
SOURCES=bootloader.asm kernel.asm constants.asm filesystem.asm terminal.asm users.asm
OBJECTS=$(SOURCES:.asm=.bin)

# Directorio de salida
BUILD_DIR=build
ISO_DIR=iso/boot

.PHONY: all clean run

all: diegOS.iso

# Crear directorios necesarios
$(BUILD_DIR) $(ISO_DIR):
	mkdir -p $@

# Compilar archivos .asm
%.bin: %.asm
	$(ASM) $(ASMFLAGS) $< -o $(BUILD_DIR)/$@

# Crear imagen de disco
disk.img: $(OBJECTS) | $(BUILD_DIR)
	dd if=/dev/zero of=$(BUILD_DIR)/disk.img bs=512 count=2880
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/disk.img conv=notrunc bs=512 count=1
	dd if=$(BUILD_DIR)/kernel.bin of=$(BUILD_DIR)/disk.img conv=notrunc bs=512 seek=1

# Crear ISO
diegOS.iso: disk.img | $(ISO_DIR)
	cp $(BUILD_DIR)/disk.img $(ISO_DIR)/
	genisoimage -o $@ -b boot/disk.img -no-emul-boot -boot-load-size 4 iso/

# Ejecutar en QEMU
run: diegOS.iso
	$(QEMU) $(QEMUFLAGS)

# Limpiar archivos compilados
clean:
	rm -rf $(BUILD_DIR) iso diegOS.iso
