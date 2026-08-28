#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
     kvantum       \
     lxqt-qtplugin \
     qt6-base      \
     qt6ct

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package uefitool-ng

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
echo "Building UEFITool..."
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
