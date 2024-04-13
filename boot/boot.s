; boot start

MBOOT_HEADER_MAGIC equ 0x1BADB002

MBOOT_PAGE_ALGIN equ 1 << 0 
MBOOT_MEM_INFO equ 1 << 1

MBOOT_HEAD_FLAGS equ MBOOT_PAGE_ALGIN | MBOOT_MEM_INFO ; headr 标记

MBOOT_CHECKSUM equ -(MBOOT_HEADER_MAGIC + MBOOT_HEAD_FLAGS) ; checksum 要求checksum flag magic 之和为0

; 符合Multiboot规范的 OS 映象需要这样一个 magic Multiboot 头
; Multiboot 头的分布必须如下表所示：
; ----------------------------------------------------------
; 偏移量  类型  域名        备注
;
;   0     u32   magic       必需
;   4     u32   flags       必需 
;   8     u32   checksum    必需 
;-----------------------------------------------------------


[BITS 32]
section .text

dd MBOOT_HEADER_MAGIC
dd MBOOT_HEAD_FLAGS
dd MBOOT_CHECKSUM

[GLOBAL start]
[GLOBAL glb_mboot_ptr]
[EXTERN kern_entry]

start:
    cli ; close interrupt / real mode 

    mov esp, STACK_TOP
    mov ebp, 0
    and esp, 0FFFFFFF0H
    mov [glb_mboot_ptr], ebx
    call kern_entry

stop:
    hlt
    jmp stop

section .bss

stack:
    resb 32768

glb_mboot_ptr:
    resb 4

STACK_TOP equ $-stack -1

