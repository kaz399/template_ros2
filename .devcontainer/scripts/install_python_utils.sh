#!/usr/bin/env bash
set -eu
cd ~/

source ~/.bashrc

python3 -m venv --system-site-packages ~/.venv
source ~/.venv/bin/activate

PACKAGES="\
    colcon-common-extensions \
    rosdep \
    vcstool \
    argcomplete \
    empy \
    uv \
    isort \
    flake8 \
    black \
    mypy \
    ruff \
    pyright \
    ros2-pkg-create \
"

for package in ${PACKAGES} ; do
    pip install -U ${package}
done
