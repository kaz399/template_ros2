ARG ROS_DISTRO=jazzy
FROM osrf/ros:${ROS_DISTRO}-desktop-full

ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=${USER_UID}


# Delete user if it exists in container (e.g Ubuntu Noble: ubuntu)
RUN if id -u ${USER_UID} ; then userdel `id -un ${USER_UID}` ; fi || true

# Install base packages
RUN apt-get update
# RUN apt-get upgrade -y
COPY ./turtlebot3/install-${ROS_DISTRO}-turtlebot3-packages.sh /tmp/
RUN /tmp/install-${ROS_DISTRO}-turtlebot3-packages.sh
RUN apt-get install -y python3-pip

# Install packages for developing
RUN apt-get install -y build-essential git
RUN apt-get install -y python-is-python3 pipx less ripgrep fd-find colordiff tree vim
RUN apt-get install -y libopencv-contrib-dev
RUN ln -s /usr/bin/fdfind /usr/bin/fd

# Create the user
RUN groupadd --gid ${USER_GID} ${USERNAME}
RUN useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}
RUN apt-get update && apt-get install -y sudo \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

ENV SHELL=/bin/bash

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER ${USERNAME}
WORKDIR /home/${USERNAME}/ws
RUN echo ". /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/${USERNAME}/.bashrc
RUN echo ". /usr/share/gazebo/setup.bash" >> /home/${USERNAME}/.bashrc
RUN echo "export GAZEBO_MODEL_PATH=\${GAZEBO_MODEL_PATH}:/opt/ros/${ROS_DISTRO}/share/turtlebot3_gazebo/models" >> /home/${USERNAME}/.bashrc
RUN echo "export TURTLEBOT3_MODEL=burger" >> /home/${USERNAME}/.bashrc
CMD ["/bin/bash"]
