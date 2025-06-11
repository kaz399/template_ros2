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

RENDER_GID=$(getent group render | cut -d: -f3)

DISPLAY=${DISPLAY:-unix:0}

if [[ ! -d ${REPOSITORY_ROOT}/commandhistory ]] ; then
  mkdir ${REPOSITORY_ROOT}/commandhistory
fi

if [[ -n "${CONTAINER_ID}" ]] ; then
  echo "into the running container '${CONTAINER_NAME}':${CONTAINER_ID}"
  docker exec -it ${CONTAINER_ID} bash
else
  echo "start container '${CONTAINER_NAME}'"
  if [[ -z "${SSH_CLIENT:-}" ]] ; then
    xhost +local:${USER}
  fi
  docker run \
    --privileged \
    -it \
    --hostname ${HOSTNAME} \
    --net=host \
    --pid=host \
    --ipc=host \
    --group-add ${RENDER_GID} \
    -v ${REPOSITORY_ROOT}:/home/${ROS_USERNAME}/ws \
    -e DISPLAY=${DISPLAY} \
    -e ROS_AUTOMATIC_DISCOVERY_RANGE=LOCALHOST \
    -e ROS_DOMAIN_ID=42 \
    -e TERM=${TERM} \
    -e SRC_ENDPOINT=${SRC_ENDPOINT} \
    -e SRC_ACCESS_TOKEN=${SRC_ACCESS_TOKEN} \
    -v /mnt/wslg:/mnt/wslg \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev/dri:/dev/dri \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ${HOME}/.Xauthority:/home/${ROS_USERNAME}/.Xauthority \
    -v ${HOME}/.gitconfig:/home/${ROS_USERNAME}/.gitconfig \
    -v ${HOME}/.gitignore:/home/${ROS_USERNAME}/.gitignore \
    -v ${HOME}/.ssh:/home/${ROS_USERNAME}/.ssh \
    -v ${HOME}/.vim:/home/${ROS_USERNAME}/.vim \
    -v ${HOME}/.local/share/nvim:/home/${ROS_USERNAME}/.local/share/nvim \
    -v ${HOME}/.config/nvim:/home/${ROS_USERNAME}/.config/nvim \
    -v ${HOME}/.emacs.d:/home/${ROS_USERNAME}/.emacs.d \
    -v ${REPOSITORY_ROOT}/commandhistory:/commandhistory \
    ${CONTAINER_NAME}
  if [[ -z "${SSH_CLIENT}" ]] ; then
    xhost -local:${USER}
  fi
fi
