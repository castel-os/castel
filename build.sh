#!/usr/bin/mksh
set -e

print "=== Castel Build starting ==="

mkdir -p "$HOME/Castel/build"
CASTEL_BUILD="$HOME/Castel/build"
CASTEL="$HOME/Castel"

cd "$CASTEL" && ./scripts/create-disk.sh

print "=== Caste Base Build Starting ==="

cd "$CASTEL_BUILD" && "$CASTEL/scripts/shell.sh"

cd "$CASTEL_BUILD" && "$CASTEL/scripts/coreutils.sh"

cd "$CASTEL_BUILD" && "$CASTEL/scripts/libc.sh"

cd "$CASTEL_BUILD" && "$CASTEL/scripts/init.sh"

cd "$CASTEL_BUILD" && "$CASTEL/scripts/dbus.sh"

cd "$CASTEL_BUILD" && "$CASTEL/scripts/kernel.sh"

cd "$CASTEL_BUILD" && "$CASTEL/scripts/limine.sh"

cd "$CASTEL_BUILD" && "$CASTEL/scripts/iso.sh"

cd "$CASTEL_BUILD" && "$CASTEL/scripts/run.sh"