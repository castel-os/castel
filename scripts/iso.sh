#!/usr/bin/mksh

set -e

print "=== Building ISO ==="

ISO_ROOT="$HOME/Castel/iso_root"
rm -rf "$ISO_ROOT"
mkdir -p "$ISO_ROOT/boot" "$ISO_ROOT/EFI/BOOT" "$ISO_ROOT/limine"

print "Copying kernel and Limine files into ISO tree..."
cp linux-7.1.1/arch/x86/boot/bzImage "$ISO_ROOT/vmlinuz"
cp limine-binary/BOOTX64.EFI "$ISO_ROOT/EFI/BOOT/"
cp limine-binary/limine-uefi-cd.bin "$ISO_ROOT/boot/"

cat > "$ISO_ROOT/limine/limine.conf" <<'LIMCFG'
timeout: 3

/Castel
    protocol: linux
    kernel_path: boot():/vmlinuz
    cmdline: root=/dev/vda2 rw init=/castel/bin/init console=tty0 console=ttyS0
LIMCFG

print "Running xorriso..."

rm -f $HOME/Castel/castel.iso

xorriso -as mkisofs \
    --efi-boot boot/limine-uefi-cd.bin \
    -efi-boot-part --efi-boot-image --protective-msdos-label \
    "$ISO_ROOT" -o "$HOME/Castel/castel.iso"

LOOP_DEV=$(sudo losetup -j "$HOME/Castel/castel.img" | cut -d: -f1)
sudo umount /mnt/boot
sudo umount /mnt
sudo losetup -D

print "=== ISO ready at $HOME/Castel/castel.iso ==="