#!/usr/bin/env bash
set -eu

if [[ -f /.dockerenv ]] ; then
  echo "ERROR: inside container"
  exit 1
fi

ROS_DISTRO=${ROS_DISTRO:-jazzy}

#CONTAINER_NAME=my_ros:latest
CONTAINER_NAME=$(basename $(git rev-parse --show-toplevel))-$(git rev-parse --abbrev-ref HEAD):latest
REPOSITORY_ROOT=$(git rev-parse --show-toplevel)

docker build -t ${CONTAINER_NAME} \
  --build-arg ROS_DISTRO=${ROS_DISTRO} \
  --build-arg USER_UID=$(id -u) \
  --build-arg USER_GID=$(id -g) \
  --build-arg DOCKER_GID=$(getent group docker | cut -d: -f3) \
  ${REPOSITORY_ROOT}/.devcontainer \
  ${@}



