#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q uefitool-ng | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/LongSoft/UEFITool/refs/heads/new_engine/UEFITool/icons/uefitool_256x256.png

# Deploy dependencies
quick-sharun /usr/bin/uefitool

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --test ./dist/*.AppImage
