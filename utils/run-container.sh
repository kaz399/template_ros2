#!/usr/bin/env bash
set -eu

if [[ -f /.dockerenv ]] ; then
  echo "ERROR: inside container"
  exit 1
fi

CONTAINER_NAME=$(basename $(git rev-parse --show-toplevel))-$(git rev-parse --abbrev-ref HEAD):latest
CONTAINER_ID=$(docker ps | grep ${CONTAINER_NAME} | cut -d ' ' -f 1)

REPOSITORY_ROOT=$(git rev-parse --show-toplevel)
ROS_USERNAME=ros

DISPLAY=unix:0

if [[ ! -d ${REPOSITORY_ROOT}/commandhistory ]] ; then
  mkdir ${REPOSITORY_ROOT}/commandhistory
fi

if [[ -n "${CONTAINER_ID}" ]] ; then
  echo "into the running container '${CONTAINER_NAME}':${CONTAINER_ID}"
  docker exec -it ${CONTAINER_ID} bash
else
  echo "start container '${CONTAINER_NAME}'"
  xhost +local:${USER}
  docker run \
    --privileged \
    -it \
    --hostname ${HOSTNAME} \
    --net=host \
    --pid=host \
    --ipc=host \
    -v ${REPOSITORY_ROOT}:/home/${ROS_USERNAME}/ws \
    -e DISPLAY=${DISPLAY} \
    -e ROS_LOCALHOST_ONLY=1 \
    -e ROS_DOMAIN_ID=42 \
    -v ${HOME}/.ssh:/home/${ROS_USERNAME}/.ssh \
    -v ${HOME}/.vim:/home/${ROS_USERNAME}/.vim \
    -v ${HOME}/.local/share/nvim:/home/${ROS_USERNAME}/.local/share/nvim \
    -v ${HOME}/.config/nvim:/home/${ROS_USERNAME}/.config/nvim \
    -v ${HOME}/.emacs.d:/home/${ROS_USERNAME}/.emacs.d \
    -v ${REPOSITORY_ROOT}/commandhistory:/commandhistory \
    ${CONTAINER_NAME}
  xhost -local:${USER}
fi
