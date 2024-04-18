#!Makefile

C_SOURCES = $(shell find . -name "*.c")
C_OBJECTS = $(patsubst %.c, %.o, $(C_SOURCES))
S_SOURCES = $(shell find . -name "*.s")
S_OBJECTS = $(patsubst %.s, %.o, $(S_SOURCES))
CPP_SOURCES = $(shell find . -name "*.cpp")
CPP_OBJECTS = $(patsubst %.cpp, %.o, $(CPP_SOURCES))

CC = gcc
LD = ld
ASM = nasm
CXX = g++

CXX_FLAGS = -c -Wall -m32 -ggdb -nostdinc -fno-builtin -fno-exceptions -fno-rtti -I include
C_FLAGS = -c -Wall -m32 -ggdb -gstabs+ -nostdinc -fno-builtin -fno-stack-protector -I include
LD_FLAGS = -T scripts/kernel.ld -m32 -nostdlib -Wl,-melf_i386
ASM_FLAGS = -f elf -g -F stabs

all: $(S_OBJECTS) $(C_OBJECTS) $(CPP_OBJECTS) link update_image

# The automatic variable `$<' is just the first prerequisite
.c.o:
	@echo 编译代码文件 $< ...
	$(CC) $(C_FLAGS) $< -o $@

.s.o:
	@echo 编译汇编文件 $< ...
	$(ASM) $(ASM_FLAGS) $< -o $@

.cpp.o:
	@echo 编译 C++ 文件 $< ...
	$(CXX) $(CXX_FLAGS) $< -o $@

link:
	@echo 链接内核文件...
	$(CXX) $(LD_FLAGS) $(S_OBJECTS) $(C_OBJECTS) $(CPP_OBJECTS) -o mhc_kernel

.PHONY:clean
clean:
	$(RM) $(S_OBJECTS) $(C_OBJECTS) $(CPP_OBJECTS) mhc_kernel

.PHONY:update_image
update_image:
	sudo mount hd.img /mnt/kernel
	sudo cp mhc_kernel /mnt/kernel/mhc_kernel
	sleep 1
	sudo umount /mnt/kernel

.PHONY:mount_image
mount_image:
	sudo mount hd.img /mnt/kernel

.PHONY:umount_image
umount_image:
	sudo umount /mnt/kernel

.PHONY:qemu
qemu:
	qemu-system-i386 -fda hd.img -boot a -nographic	
	#add '-nographic' option if using server of linux distro, such as fedora-server,or "gtk initialization failed" error will occur.

.PHONY:vnc
vnc:
	qemu-system-i386 -kernel mhc_kernel -vnc :1

.PHONY:debug
debug:
	qemu-system-i386 -S -s -fda hd.img -boot a &
	sleep 1
	cgdb -x scripts/gdbinit

