#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOTFS="$PROJECT_ROOT/build/rootfs"

echo "========================================"
echo "        Syntax OS Customizer"
echo "========================================"

if [ ! -d "$ROOTFS/etc" ]; then
    echo "ERROR: rootfs not found."
    echo "Run ./scripts/build.sh first."
    exit 1
fi

echo "[1/5] Mounting chroot..."

"$PROJECT_ROOT/scripts/mount-chroot.sh"

echo "[2/5] Preparing package lists..."

sudo cp "$PROJECT_ROOT/config/packages/base.txt" \
    "$ROOTFS/tmp/syntax-base.txt"

sudo cp "$PROJECT_ROOT/config/packages/development.txt" \
    "$ROOTFS/tmp/syntax-development.txt"

echo "[3/5] Installing packages..."

sudo chroot "$ROOTFS" /bin/bash <<'CHROOT'

set -e

export DEBIAN_FRONTEND=noninteractive

apt update

apt install -y \
    $(grep -v '^#' /tmp/syntax-base.txt | grep -v '^$')

apt install -y \
    $(grep -v '^#' /tmp/syntax-development.txt | grep -v '^$')

apt clean

rm -f /tmp/syntax-base.txt
rm -f /tmp/syntax-development.txt

CHROOT

echo "[4/5] Applying Syntax OS identity..."

sudo tee "$ROOTFS/etc/os-release" > /dev/null <<'EOF'
NAME="Syntax OS"
PRETTY_NAME="Syntax OS"
ID=syntax
ID_LIKE=ubuntu
VERSION_ID="0.1.0"
VERSION="0.1.0"
VERSION_CODENAME="development"
EOF

echo "[5/5] Cleaning..."

sudo rm -rf "$ROOTFS/tmp/"*

"$PROJECT_ROOT/scripts/umount-chroot.sh"

echo
echo "========================================"
echo "        Syntax OS customization done"
echo "========================================"
