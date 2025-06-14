#!/usr/bin/env bash
set -eu
source ~/.bashrc
export PIPX_HOME=/home/${USER}/.local/share/pipx/venvs
PACKAGES="\
    uv \
    isort\
    flake8\
    black\
    mypy\
    ruff\
    pyright \
    ros2-pkg-create \
"

for package in ${PACKAGES} ; do
    pipx install ${package}
done
