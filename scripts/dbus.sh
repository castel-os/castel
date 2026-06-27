#!/usr/bin/mksh

set -e

print "Downloading expat source..."

wget -nc https://github.com/libexpat/libexpat/releases/download/R_2_8_2/expat-2.8.2.tar.gz
tar -xf expat-2.8.2.tar.gz
cd expat-2.8.2

print "Compiling expat..."

CC="zig cc -target x86_64-linux.7.0-musl" \
CFLAGS="-I/mnt/castel/include" \
LDFLAGS="-L/mnt/castel/lib -lc -Wl,-rpath,/castel/lib" \
./configure --prefix=/castel --host=x86_64-linux-musl
make -j$(nproc)
sudo make DESTDIR=/mnt install
cd ..

print "=== expat installed ==="

print "Downloading dbus source..."
wget -nc https://gitlab.freedesktop.org/dbus/dbus/-/archive/dbus-1.16.2/dbus-dbus-1.16.2.tar.gz
tar -xf dbus-dbus-1.16.2.tar.gz

rm -rf dbus
mkdir dbus

print "Configuring D-Bus with Meson..."
CFLAGS="-I/mnt/castel/include" \
LDFLAGS="-L/mnt/castel/lib -lc -Wl,-rpath,/castel/lib" \
PKG_CONFIG_LIBDIR=/mnt/castel/lib/pkgconfig \
PKG_CONFIG_SYSROOT_DIR=/mnt \
CC=/tmp/zigcc \
meson setup dbus dbus-dbus-1.16.2 \
    --wrap-mode=nofallback \
    --prefix=/castel \
    --sysconfdir=/etc \
    --localstatedir=/var \
    -Dsystemd=disabled \
    -Dapparmor=disabled \
    -Dselinux=disabled \
    -Dlibaudit=disabled \
    -Dx11_autolaunch=disabled \
    -Dtools=true \
    -Dmessage_bus=true

print "Compiling dbus..."
ninja -C dbus

print "installing into Castel..."
sudo DESTDIR=/mnt ninja -C dbus install

print "=== dbus installed ==="