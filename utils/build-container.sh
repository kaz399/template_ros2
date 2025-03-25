#!/usr/bin/env bash
set -eu

if [[ -f /.dockerenv ]] ; then
  echo "ERROR: inside container"
  exit 1
fi


#CONTAINER_NAME=my_ros:latest
CONTAINER_NAME=$(basename $(git rev-parse --show-toplevel))-$(git rev-parse --abbrev-ref HEAD):latest
REPOSITORY_ROOT=$(git rev-parse --show-toplevel)

docker build -t ${CONTAINER_NAME} \
  --build-arg USER_UID=$(id -u) \
  --build-arg USER_GID=$(id -g) \
  ${REPOSITORY_ROOT}/.devcontainer


