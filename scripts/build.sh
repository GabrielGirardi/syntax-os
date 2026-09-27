#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

BUILD_DIR="$PROJECT_ROOT/build"
ISO="$BUILD_DIR/ubuntu.iso"

WORK_DIR="$BUILD_DIR/work"
MOUNT_DIR="$BUILD_DIR/mnt"
ROOTFS="$BUILD_DIR/rootfs"

echo "========================================"
echo "        SyntaxOS ISO Builder"
echo "========================================"

if [ ! -f "$ISO" ]; then
    echo "ERROR: Ubuntu ISO not found:"
    echo "$ISO"
    exit 1
fi

echo "[1/6] Preparing build directories..."

rm -rf "$WORK_DIR"
rm -rf "$MOUNT_DIR"
rm -rf "$ROOTFS"

mkdir -p "$WORK_DIR"
mkdir -p "$MOUNT_DIR"
mkdir -p "$ROOTFS"

echo "[2/6] Mounting Ubuntu ISO..."

sudo mount -o loop "$ISO" "$MOUNT_DIR"

echo "[3/6] Copying ISO contents..."

rsync -a \
    --exclude=/casper/filesystem.squashfs \
    "$MOUNT_DIR/" \
    "$WORK_DIR/"

echo "[4/6] Extracting Ubuntu filesystem..."

sudo unsquashfs \
    -d "$ROOTFS" \
    "$MOUNT_DIR/casper/filesystem.squashfs"

echo "[5/6] Filesystem extracted."

echo "[6/6] Build environment ready."

sudo umount "$MOUNT_DIR"

echo
echo "========================================"
echo "Filesystem ready:"
echo "$ROOTFS"
echo "========================================"