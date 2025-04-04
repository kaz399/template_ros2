ARG ROS_DISTRO=noetic
FROM osrf/ros:${ROS_DISTRO}-desktop-full

ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

ENV DEBIAN_FRONTEND=noninteractive

# Delete user if it exists in container (e.g Ubuntu Noble: ubuntu)
RUN if id -u ${USER_UID} ; then userdel `id -un ${USER_UID}` ; fi || true

# Install base packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y x11-apps
RUN apt-get install -y python3-pip
RUN apt-get install -y python3-rosdep
RUN apt-get install -y python3-colcon-common-extensions
RUN apt-get install -y python3-vcstool
RUN apt-get install -y python3-catkin-tools
RUN apt-get install -y ros-noetic-dynamixel-sdk
RUN apt-get install -y ros-noetic-turtlebot3
RUN apt-get install -y ros-noetic-turtlebot3-simulations
RUN rosdep update

# Install packages for developing
RUN apt-get install -y build-essential git
RUN apt-get install -y python-is-python3 pipx less ripgrep fd-find colordiff tree vim source-highlight x11vnc
RUN apt-get install -y libopencv-contrib-dev

# setup for installed packages
RUN ln -s /usr/bin/fdfind /usr/bin/fd
RUN echo 'export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"' >> /etc/bash.bashrc && \
    echo 'export LESS=" -R "' >> /etc/bash.bashrc && \
    echo 'alias diff="colordiff"' >> /etc/bash.bashrc && \
    echo 'alias rgall="rg --follow --no-ignore --color=always"' >> /etc/bash.bashrc && \
    echo 'alias rg="rg --color=always"' >> /etc/bash.bashrc && \
    echo 'alias fdall="\\fd --no-ignore-vcs --color=always"' >> /etc/bash.bashrc && \
    echo 'alias fd="\\fd --color=always"' >> /etc/bash.bashrc

# Create the user
RUN groupadd --gid ${USER_GID} ${USERNAME}
RUN useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}
RUN apt-get update && apt-get install -y sudo \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

ENV SHELL=/bin/bash

# RUN rm -rf /var/lib/apt/lists/*

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
