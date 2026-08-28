#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q uefitool-ng | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/LongSoft/UEFITool/refs/heads/new_engine/UEFITool/icons/uefitool_256x256.png
export DEPLOY_QT=1
export QT_DIR=qt6
export ALWAYS_SOFTWARE=1

# Deploy dependencies
quick-sharun /usr/bin/uefitool

# Turn AppDir into AppImage
quick-sharun --make-appimage
