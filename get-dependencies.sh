#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
     cmake         \
     kvantum       \
     lxqt-qtplugin \
     qt6-base      \
     qt6ct

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building stable version of UEFITool..."
echo "---------------------------------------------------------------"
REPO="https://github.com/LongSoft/UEFITool"
VERSION="$(curl -s https://api.github.com/repos/LongSoft/UEFITool/releases/latest | grep '"tag_name"' | cut -d '"' -f 4)"
git clone "$REPO" ./UEFITool
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./UEFITool
cmake -S ./ -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc)
mv -v build/UEFIExtract/uefiextract build/UEFIFind/uefifind build/UEFITool/uefitool ../AppDir/bin
