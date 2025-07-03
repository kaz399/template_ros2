#!/usr/bin/env bash
set -eu
cd ~/

source ~/.bashrc

python -m venv ~/.venv
source ~/.venv/bin/activate

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
    pip install ${package}
done
