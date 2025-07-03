#!/usr/bin/env bash
set -eu

source ~/.bashrc

python3 -m venv --system-site-packages ~/.venv
source ~/.venv/bin/activate

PACKAGES="\
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
