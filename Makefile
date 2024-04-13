#!Makefile

C_SOURCES = $(shell find . -name "*.c")
C_OBJECTS = $(patsubst %.c, %.o, $(C_SOURCES))
S_SOURCES = $(shell find . -name "*.s")
S_OBJECTS = $(patsubst %.s, %.o, $(S_SOURCES))


CC = gcc
LD = ld
ASM = nasm

C_FLAGS = -c -Wall -m32 -ggdb -gstabs+ -nostdinc -fno-pic -fno-builtin -fno-stack-protector -I include
LD_FLAGS = -T scripts/kernel.ld -m elf_i386 -nostdlib
ASM_FLAGS = -f elf -g -F stabs

all: $(S_OBJECTS) $(C_OBJECTS) link update_image

.c.o:
	@echo 编译代码文件 $< ... 
	$(CC) $(C_FLAGS) $< -o $@

.s.o:
	@echo 编译汇编文件 $< ...
	$(ASM) $(ASM_FLAGS) $< -o $@

link:
	@echo 链接内核文件...
	$(LD) $(LD_FLAGS) $(S_OBJECTS) $(C_OBJECTS) -o mhc_kernel



.PHONY:clean
clean:
	$(RM) $(S_OBJECTS) $(C_OBJECTS) mhc_kernel

.PHONY:qemu
qemu:
	qemu-system-x86_64 -hda hd.img -m 1024 -boot c -nographic

	

.PHONY:update_image
update_image:
	sudo mount hd.img /mnt/kernel
	sudo cp mhc_kernel /mnt/kernel/mhc_kernel
	sleep 1
	sudo umount /mnt/kernel