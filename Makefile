# Build bootloader

# Check if nasm is installed
nasm := $(shell command -v nasm 2> /dev/null)
ifeq ($(nasm),)
$(error "nasm is not installed")
endif

nasm_bin = nasm
path_to_bootloader = ./src/boot/bootloader.asm
include_dir = ./src/boot/
out_dir = ./out

# check if out directory exists
ifeq ($(wildcard $(out_dir)),)
$(shell mkdir $(out_dir))
endif

bootloader.bin: $(path_to_bootloader)
	$(nasm_bin) -i$(include_dir) -f bin -o $(out_dir)/bootloader.bin $(path_to_bootloader)

clear:
	rm -f $(out_dir)/bootloader.bin