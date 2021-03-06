
# This file is a part of MRNIU/SimpleKernel (https://github.com/MRNIU/SimpleKernel).
# boot.s for MRNIU/SimpleKernel.

# multiboot2 定义
.set  MULTIBOOT_SEARCH,                        32768
.set  MULTIBOOT_HEADER_ALIGN,                  8
.set  MULTIBOOT2_HEADER_MAGIC,                 0xe85250d6
.set  MULTIBOOT2_BOOTLOADER_MAGIC,             0x36d76289
.set  MULTIBOOT_MOD_ALIGN,                     0x00001000
.set  MULTIBOOT_INFO_ALIGN,                    0x00000008

.set  MULTIBOOT_TAG_ALIGN,                  8
.set  MULTIBOOT_TAG_TYPE_END,               0
.set  MULTIBOOT_TAG_TYPE_CMDLINE,           1
.set  MULTIBOOT_TAG_TYPE_BOOT_LOADER_NAME,  2
.set  MULTIBOOT_TAG_TYPE_MODULE,            3
.set  MULTIBOOT_TAG_TYPE_BASIC_MEMINFO,     4
.set  MULTIBOOT_TAG_TYPE_BOOTDEV,           5
.set  MULTIBOOT_TAG_TYPE_MMAP,              6
.set  MULTIBOOT_TAG_TYPE_VBE,               7
.set  MULTIBOOT_TAG_TYPE_FRAMEBUFFER,       8
.set  MULTIBOOT_TAG_TYPE_ELF_SECTIONS,      9
.set  MULTIBOOT_TAG_TYPE_APM,               10
.set  MULTIBOOT_TAG_TYPE_EFI32,             11
.set  MULTIBOOT_TAG_TYPE_EFI64,             12
.set  MULTIBOOT_TAG_TYPE_SMBIOS,            13
.set  MULTIBOOT_TAG_TYPE_ACPI_OLD,          14
.set  MULTIBOOT_TAG_TYPE_ACPI_NEW,          15
.set  MULTIBOOT_TAG_TYPE_NETWORK,           16
.set  MULTIBOOT_TAG_TYPE_EFI_MMAP,          17
.set  MULTIBOOT_TAG_TYPE_EFI_BS,            18
.set  MULTIBOOT_TAG_TYPE_EFI32_IH,          19
.set  MULTIBOOT_TAG_TYPE_EFI64_IH,          20
.set  MULTIBOOT_TAG_TYPE_LOAD_BASE_ADDR,    21

.set  MULTIBOOT_HEADER_TAG_END,  0
.set  MULTIBOOT_HEADER_TAG_INFORMATION_REQUEST,  1
.set  MULTIBOOT_HEADER_TAG_ADDRESS,  2
.set  MULTIBOOT_HEADER_TAG_ENTRY_ADDRESS,  3
.set  MULTIBOOT_HEADER_TAG_CONSOLE_FLAGS,  4
.set  MULTIBOOT_HEADER_TAG_FRAMEBUFFER,  5
.set  MULTIBOOT_HEADER_TAG_MODULE_ALIGN,  6
.set  MULTIBOOT_HEADER_TAG_EFI_BS,        7
.set  MULTIBOOT_HEADER_TAG_ENTRY_ADDRESS_EFI32,  8
.set  MULTIBOOT_HEADER_TAG_ENTRY_ADDRESS_EFI64,  9
.set  MULTIBOOT_HEADER_TAG_RELOCATABLE,  10

.set  MULTIBOOT_ARCHITECTURE_I386,  0
.set  MULTIBOOT_ARCHITECTURE_MIPS32,  4
.set  MULTIBOOT_HEADER_TAG_OPTIONAL, 1

.set  MULTIBOOT_LOAD_PREFERENCE_NONE, 0
.set  MULTIBOOT_LOAD_PREFERENCE_LOW, 1
.set  MULTIBOOT_LOAD_PREFERENCE_HIGH, 2

.set  MULTIBOOT_CONSOLE_FLAGS_CONSOLE_REQUIRED, 1
.set  MULTIBOOT_CONSOLE_FLAGS_EGA_TEXT_SUPPORTED, 2

# 设置栈大小
.set STACK_SIZE, 0x4000

.section .multiboot_header
# multiboot2 文件头
.align 8
multiboot_header:
  .long MULTIBOOT2_HEADER_MAGIC
  .long MULTIBOOT_ARCHITECTURE_I386
  .long multiboot_header_end - multiboot_header
  .long -(MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + multiboot_header_end - multiboot_header)

# 添加其它内容在此，详细信息见 Multiboot2 Specification version 2.0.pdf

# multiboot2 information request
.align 8
mbi_tag_start:
  .short MULTIBOOT_HEADER_TAG_INFORMATION_REQUEST
  .short MULTIBOOT_HEADER_TAG_OPTIONAL
  .long mbi_tag_end - mbi_tag_start
  .long MULTIBOOT_TAG_TYPE_CMDLINE
  .long MULTIBOOT_TAG_TYPE_MODULE
  .long MULTIBOOT_TAG_TYPE_BOOTDEV
  .long MULTIBOOT_TAG_TYPE_MMAP
  .long MULTIBOOT_TAG_TYPE_ELF_SECTIONS
  .long MULTIBOOT_TAG_TYPE_APM
  .long MULTIBOOT_TAG_TYPE_LOAD_BASE_ADDR
.align 8
mbi_tag_end:
	.short MULTIBOOT_HEADER_TAG_END
  .short 0
  .long 8
multiboot_header_end:

.text
.global start, _start
.global glb_multi_ptr
.extern kernel_main

start:
_start:
  jmp multiboot_entry

multiboot_entry:
	# 设置栈地址
  mov $stack_top, %esp
  push $0
  popf
	# multiboot2_info 结构体指针
  push %ebx
#  mov %ebx, (glb_multi_ptr)
	# 魔数
	push %eax
  call kernel_main
  cli
1:
  hlt
  jmp 1b
  ret

.size _start, . - _start

.section .bss

.align 8
stack_bottom:
  .skip STACK_SIZE
stack_top:
#glb_multi_ptr:
#  .skip 4

edata:
end:
