#!/usr/bin/mksh

set -e

print "=== Castel environment starting ==="

print "=== Create Castel folder ==="
mkdir -p "$HOME/Castel"

print "=== Create Castel virtual disk (4GB Sparse) ==="
rm -f "$HOME/Castel/castel.img"
truncate -s 4G "$HOME/Castel/castel.img"

print "=== Create partitions automatically (sfdisk) ==="
sfdisk "$HOME/Castel/castel.img" <<EOF
label: gpt
size=512M, type=uefi
type=linux
EOF

print "=== Create loop device ==="
LOOP_DEV=$(sudo losetup -Pf --show "$HOME/Castel/castel.img")
print "Loop device create at $LOOP_DEV"

print "=== Making filesystems ==="
sudo mkfs.fat -F 32 "${LOOP_DEV}p1"
sudo mkfs.ext4 "${LOOP_DEV}p2"

print "=== Mount partitions ==="
sudo mount "${LOOP_DEV}p2" /mnt/
sudo mkdir -p /mnt/boot
sudo mount "${LOOP_DEV}p1" /mnt/boot

print "=== Creating FHS folders ==="
sudo mkdir -p /mnt/{dev,etc,home,proc,root,sys,tmp,castel,var,run,apps}
sudo mkdir -p /mnt/castel/{bin,lib,share}

print "=== Creating for compatibility symlinks ==="

sudo ln -s castel/bin /mnt/bin
sudo ln -s castel/bin /mnt/sbin
sudo ln -s castel/lib /mnt/lib
sudo ln -s castel/lib /mnt/lib64
sudo ln -s castel /mnt/usr
sudo ln -s ../run /mnt/var/run
sudo ln -s apps /mnt/opt

print "=== Creating internal castel symlinks ==="
sudo ln -s bin /mnt/castel/sbin
sudo ln -s lib /mnt/castel/lib64

print "=== Creating base system files ==="

sudo tee /mnt/etc/os-release > /dev/null <<'EOF'
NAME="Castel"
VERSION="0.1"
ID=castel
PRETTY_NAME="Castel 0.1"
EOF

sudo tee /mnt/etc/passwd > /dev/null <<'EOF'
root::0:0:root:/root:/castel/bin/sh
EOF

sudo tee /mnt/etc/group > /dev/null <<'EOF'
root:x:0:
EOF

sudo tee /mnt/etc/fstab > /dev/null <<'EOF'
/dev/vda2   /       ext4    defaults    0 1
/dev/vda1   /boot   vfat    defaults    0 2
EOF

echo "castel" | sudo tee /mnt/etc/hostname > /dev/null

print "=== Base system files created ==="

print "=== Environment completed successfully! ==="