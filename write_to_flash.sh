#!/bin/bash

# This script is used to write the bootloader to the flash memory 

# Check if the script is run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Check if the script is run from the correct directory
if [ ! -f "bootloader.bin" ]; then
    echo "Please run the script from the directory containing the bootloader.bin file"
    exit
fi

# Get path to the flash from user
echo "Please enter the path to the flash memory (e.g. /dev/sdb):"
read flash_path

# Check if the path is valid
if [ ! -b "$flash_path" ]; then
    echo "Invalid path"
    exit
fi

# Flash the bootloader and check if it was successful
echo "Flashing bootloader..."
dd if=bootloader.bin of=$flash_path
if [ $? -eq 0 ]; then
    echo "bootloader flashed successfully"
else
    echo "bootloader flashing failed"
fi