ARG ROS_DISTRO=jazzy
FROM osrf/ros:${ROS_DISTRO}-desktop-full

ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=${USER_UID}


# Delete user if it exists in container (e.g Ubuntu Noble: ubuntu)
RUN if id -u ${USER_UID} ; then userdel `id -un ${USER_UID}` ; fi || true

# Install base packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y ros-${ROS_DISTRO}-desktop ros-dev-tools python3-argcomplete
COPY ./turtlebot3/install-${ROS_DISTRO}-turtlebot3-packages.sh /tmp/
RUN /tmp/install-${ROS_DISTRO}-turtlebot3-packages.sh
RUN apt-get install -y python3-pip

# Install packages for developing
RUN apt-get install -y build-essential git curl wget unzip p7zip-full lzma
RUN apt-get install -y python-is-python3 pipx less ripgrep fd-find colordiff tree vim source-highlight x11vnc
RUN apt-get install -y libopencv-contrib-dev

COPY ./scripts/install_neovim.sh /tmp/
RUN /tmp/install_neovim.sh

# setup for installed packages
RUN ln -s /usr/bin/fdfind /usr/bin/fd
RUN echo '' > /etc/bash.bashrc && \
    echo '# add local settings ---------------------------------' > /etc/bash.bashrc && \
    echo 'export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"' >> /etc/bash.bashrc && \
    echo 'export LESS=" -R "' >> /etc/bash.bashrc && \
    echo 'export PATH="/opt/nvim/:${PATH}"' >> /etc/bash.bashrc && \
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
COPY ./scripts/set-prompt.sh /home/${USERNAME}/.set-prompt.sh

RUN echo ". /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/${USERNAME}/.bashrc
RUN echo "if [[ -f /usr/share/gazebo/setup.bash ]] ; then . /usr/share/gazebo/setup.bash; fi" >> /home/${USERNAME}/.bashrc
RUN echo "export GAZEBO_MODEL_PATH=\${GAZEBO_MODEL_PATH}:/opt/ros/${ROS_DISTRO}/share/turtlebot3_gazebo/models" >> /home/${USERNAME}/.bashrc
RUN echo "export TURTLEBOT3_MODEL=burger" >> /home/${USERNAME}/.bashrc
RUN echo "source /etc/bash_completion.d/git-prompt" >> /home/${USERNAME}/.bashrc
RUN echo "source ~/.set-prompt.sh" >> /home/${USERNAME}/.bashrc
RUN echo "alias vi=nvim" >> /home/${USERNAME}/.bashrc
CMD ["/bin/bash"]
