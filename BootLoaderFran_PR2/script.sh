#!/bin/bash
set -euo pipefail
nombre=BootLoaderFran
nasm "$nombre.asm" -f bin -o "$nombre.img"
qemu-system-x86_64 -drive file="$nombre.img",format=raw,index=0,if=floppy
