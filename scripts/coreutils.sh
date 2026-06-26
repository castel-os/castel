#!/usr/bin/mksh

set -e

print "Downloading toybox source..."
wget -nc https://landley.net/toybox/downloads/toybox-0.8.13.tar.gz
tar -xzf toybox-0.8.13.tar.gz
cd toybox-0.8.13

print "Compiling toybox..."
#EVIL HACK
cat > /tmp/zigcc <<'EOF'
#!/bin/sh
exec zig cc -target x86_64-linux.7.0-musl "$@"
EOF
chmod u+x /tmp/zigcc
CC=/tmp/zigcc make defconfig
sed -i 's/# CONFIG_GETTY is not set/CONFIG_GETTY=y/' .config
make CC=/tmp/zigcc HOSTCC="zig cc" toybox

print "Installing toybox into Castel..."
sudo cp toybox "/mnt/castel/bin/"
print "Success toybox Installed in Castel"

print "Installing toybox symlinks..."
for cmd in $(./toybox); do 
    sudo ln -sf toybox "/mnt/castel/bin/$cmd"
done
print "=== Toybox symlinks installed ==="