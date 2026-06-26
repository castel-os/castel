#!/usr/bin/mksh

set -e

print "Downloading mksh source..."
wget -nc http://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R59c.tgz
tar -xzf mksh-R59c.tgz
cd mksh

print "Compiling mksh..."
CC="zig cc -target x86_64-linux.7.0-musl" sh Build.sh -r

print "Installing mksh into Castel..."
sudo cp mksh "/mnt/castel/bin/"
sudo ln -sf mksh "/mnt/castel/bin/sh"

print "=== Success mksh Installed in Castel ===" 