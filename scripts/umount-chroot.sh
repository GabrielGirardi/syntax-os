#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOTFS="$PROJECT_ROOT/build/rootfs"

echo "[+] Unmounting chroot filesystems..."

sudo umount -R "$ROOTFS/dev" 2>/dev/null || true
sudo umount "$ROOTFS/proc" 2>/dev/null || true
sudo umount "$ROOTFS/sys" 2>/dev/null || true

echo "[+] Chroot environment unmounted."
