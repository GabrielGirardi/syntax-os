#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOTFS="$PROJECT_ROOT/build/rootfs"

if [ ! -d "$ROOTFS/etc" ]; then
    echo "ERROR: rootfs not found."
    exit 1
fi

echo "[+] Mounting chroot filesystems..."

sudo mount --bind /dev "$ROOTFS/dev"
sudo mount --bind /dev/pts "$ROOTFS/dev/pts"

sudo mount -t proc proc "$ROOTFS/proc"
sudo mount -t sysfs sys "$ROOTFS/sys"

sudo cp --dereference /etc/resolv.conf "$ROOTFS/etc/resolv.conf"

echo "[+] Chroot environment ready."
