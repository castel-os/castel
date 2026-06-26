#!/usr/bin/mksh
set -e 

CASTEL="$HOME/Castel"

print "=== Preparing runtime disk ==="
cp "$CASTEL/castel.img" "$CASTEL/castel-runtime.img"

print "=== Booting Castel ==="
qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -m 1G \
    -smp 2 \
    -bios /usr/share/edk2/x64/OVMF.4m.fd \
    -cdrom "$HOME/Castel/castel.iso" \
    -drive file="$HOME/Castel/castel-runtime.img",format=raw,if=virtio \
    -boot d \
    -vga virtio \
    -display gtk 