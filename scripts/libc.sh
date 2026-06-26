#!/usr/bin/mksh

set -e

print "Downloading musl source..."
wget -nc https://git.musl-libc.org/cgit/musl/snapshot/musl-1.2.6.tar.gz
tar -xzf musl-1.2.6.tar.gz
cd musl-1.2.6

print "Configuring and Compiling musl..."
CC="zig cc -target x86_64-linux.7.0-musl" ./configure --prefix=/castel --syslibdir=/castel/lib

make -j$(nproc)

print "Installing musl into Castel..."
sudo make DESTDIR=/mnt install
print "Success musl Installed in Castel"