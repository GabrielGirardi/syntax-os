#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

BUILD_DIR="$PROJECT_ROOT/build"
ROOTFS="$BUILD_DIR/rootfs"

echo "================================="
echo " Building SyntaxOS"
echo "================================="

echo "[1/5] Preparing directories..."

rm -rf "$BUILD_DIR"
mkdir -p "$ROOTFS"

echo "[2/5] Creating root filesystem..."

sudo debootstrap \
    --arch=amd64 \
    noble \
    "$ROOTFS" \
    http://archive.ubuntu.com/ubuntu/

echo "[3/5] Copying package lists..."

cp "$PROJECT_ROOT/config/packages/base.txt" "$ROOTFS/tmp/base.txt"
cp "$PROJECT_ROOT/config/packages/development.txt" "$ROOTFS/tmp/development.txt"

echo "[4/5] Installing packages..."

sudo chroot "$ROOTFS" /bin/bash <<'CHROOT'

export DEBIAN_FRONTEND=noninteractive

apt update

apt install -y \
    $(grep -v '^#' /tmp/base.txt | grep -v '^$')

apt install -y \
    $(grep -v '^#' /tmp/development.txt | grep -v '^$')

apt clean

CHROOT

echo "[5/5] Build filesystem ready."

echo
echo "Root filesystem:"
echo "$ROOTFS"