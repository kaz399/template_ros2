#!/usr/bin/env bash
set -eu
export PIPX_HOME=/home/${USER}/.local/share/pipx/venvs
pipx install uv poetry isort flake8 black mypy ruff pyright
