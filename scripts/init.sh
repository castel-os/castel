#!/usr/bin/mksh

set -e

print "Downloading runit source..."
wget -nc https://smarden.org/runit/runit-2.3.1.tar.gz
tar -xzf runit-2.3.1.tar.gz
cd admin/runit-2.3.1

print "Configuring compiler (Hijacking conf-cc and conf-ld)..."
echo 'zig cc -target x86_64-linux.7.0-musl -O2 -Wall' > src/conf-cc
echo 'zig cc -target x86_64-linux.7.0-musl -s' > src/conf-ld

print "Compiling runit..."
package/compile

print "Installing runit into Castel..."
sudo cp command/* /mnt/castel/bin/
sudo ln -sf runit-init /mnt/castel/bin/init
print "=== Sucess runit Installed in Castel ==="

print "=== Creating runit stage scripts ==="
sudo mkdir -p /mnt/etc/runit

sudo tee /mnt/etc/runit/1 > /dev/null <<'STAGE1'
#!/castel/bin/sh
mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t tmpfs tmpfs /run
hostname Castel
echo "STAGE1 OK"
STAGE1

sudo tee /mnt/etc/runit/2 > /dev/null <<'STAGE2'
#!/castel/bin/sh
/castel/bin/getty 38400 ttyS0 &
while true; do
    /castel/bin/getty 38400 tty1
done
STAGE2

sudo tee /mnt/etc/runit/3 > /dev/null <<'STAGE3'
#!/castel/bin/sh
echo "Castel: desligando..."
sync
STAGE3

sudo chmod +x /mnt/etc/runit/1 /mnt/etc/runit/2 /mnt/etc/runit/3
print "=== Runit stage scripts create with success ==="