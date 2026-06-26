#!/usr/bin/mksh

set -e

print "Downloading kernel source..."
wget -nc https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.1.1.tar.xz
tar -xJf linux-7.1.1.tar.xz
cd linux-7.1.1

print "Configuring kernel..."
make ARCH=x86_64 LLVM=1 LLVM_IAS=1 defconfig

scripts/config --enable MODULES
scripts/config --enable EFI
scripts/config --enable EFI_STUB
scripts/config --enable VT
scripts/config --enable FRAMEBUFFER_CONSOLE
scripts/config --enable SYSFB_SIMPLEFB
scripts/config --enable DRM
scripts/config --enable DRM_SIMPLEDRM
scripts/config --enable DRM_VIRTIO_GPU
scripts/config --enable DRM_FBDEV_EMULATION
scripts/config --enable FB
scripts/config --enable FB_CORE
scripts/config --enable VIRTIO_GPU
scripts/config --enable FB_EFI
scripts/config --enable VIRTIO
scripts/config --enable VIRTIO_PCI
scripts/config --enable VIRTIO_BLK
scripts/config --enable ATA
scripts/config --enable SATA_AHCI
scripts/config --enable BLK_DEV_NVME
scripts/config --enable USB_STORAGE
scripts/config --enable USB_XHCI_HCD
scripts/config --enable USB_EHCI_HCD
scripts/config --enable HID_GENERIC
scripts/config --enable USB_HID
scripts/config --enable NET
scripts/config --enable INET
scripts/config --enable VIRTIO_NET       
scripts/config --enable E1000E           
scripts/config --enable R8169
scripts/config --enable TMPFS        
scripts/config --enable PROC_FS        
scripts/config --enable SYSFS        
scripts/config --enable DEVTMPFS         
scripts/config --enable DEVTMPFS_MOUNT 
scripts/config --enable RANDOMIZE_BASE 
scripts/config --enable STRICT_KERNEL_RWX
scripts/config --enable ZSTD_COMPRESS
scripts/config --disable IA32_EMULATION
scripts/config --disable X86_X32
scripts/config --disable COMPAT_32
scripts/config --disable X86_16BIT
scripts/config --disable VM86
scripts/config --disable MODIFY_LDT_SYSCALL
scripts/config --disable X86_VSYSCALL_EMULATION
scripts/config --disable STAGING         
scripts/config --disable HAMRADIO        
scripts/config --disable ISDN         
scripts/config --disable PCMCIA          
scripts/config --disable PHONE       

make ARCH=x86_64 LLVM=1 LLVM_IAS=1 olddefconfig

print "Compiling kernel..."
make -j$(nproc) ARCH=x86_64 LLVM=1 LLVM_IAS=1 \
    KCFLAGS="-march=x86-64-v3" \
    KAFLAGS="-march=x86-64-v3"

print "Installing kernel..."
sudo cp arch/x86/boot/bzImage /mnt/boot/vmlinuz
print "=== Kernel build completed ==="