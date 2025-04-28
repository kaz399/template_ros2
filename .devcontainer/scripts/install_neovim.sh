#!/usr/bin/env bash
set -eu

NVIM_VERSION=0.11.1
MACHINE=$(uname -m)

sudo apt-get install -y build-essential curl wget gettext cmake ninja-build
cd /tmp
wget https://github.com/neovim/neovim/archive/refs/tags/v${NVIM_VERSION}.tar.gz
tar xvf v${NVIM_VERSION}.tar.gz
cd neovim-${NVIM_VERSION}

make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

