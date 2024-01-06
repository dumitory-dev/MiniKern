#!/bin/bash

# Check if user pass path to the kernel
if [ "$1" == "" ]; then
    echo "Please pass path to the kernel as an argument"
    exit 1
fi

# Check if file exists
if [ ! -f $1 ]; then
    echo "File $1 does not exist"
    exit 1
fi

# Run the bootloader in QEMU in nographic mode
# For exit from qemu: Ctrl + a, x
qemu-system-x86_64 -hda $1 -nographic  -serial mon:stdio


# If user pass -k 
if [ "$2" == "-k" ]; then
   sleep 10
   killall qemu-system-x86_64
fi