#!/usr/bin/mksh

set -e

print "=== Limine Bootloader Starting ==="

print "Downloading Limine binary release..."
wget -nc https://github.com/limine-bootloader/limine/releases/latest/download/limine-binary.tar.gz
tar -xzf limine-binary.tar.gz

print "Installing Limine EFI binary..."
sudo mkdir -p /mnt/boot/EFI/BOOT
sudo cp limine-binary/BOOTX64.EFI /mnt/boot/EFI/BOOT/

print "Writing limine.conf..."
sudo mkdir -p /mnt/boot/limine
sudo tee /mnt/boot/limine/limine.conf > /dev/null <<'LIMCFG'
timeout: 3

/Castel
    protocol: linux
    kernel_path: boot():/vmlinuz
    cmdline: root=/dev/vda2 rw init=/castel/bin/init console=tty0 console=ttyS0
LIMCFG

print "=== Limine installed successfully! ==="