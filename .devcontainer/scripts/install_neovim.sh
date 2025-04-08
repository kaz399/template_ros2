#!/usr/bin/env bash

set -eu

mkdir -p /opt/nvim
cd /opt/nvim
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod +x nvim-linux-x86_64.appimage
./nvim-linux-x86_64.appimage --appimage-extract
mv squashfs-root nvim_squashfs-root
ln -s ./nvim_squashfs-root/AppRun nvim




