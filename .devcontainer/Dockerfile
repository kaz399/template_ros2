ARG ROS_DISTRO=jazzy
FROM osrf/ros:${ROS_DISTRO}-desktop-full

ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ARG DOCKER_GID=984
ARG RENDER_GID=992
ARG TZ=Asia/Tokyo


# Delete user if it exists in container (e.g Ubuntu Noble: ubuntu)
RUN if id -u ${USER_UID} ; then userdel `id -un ${USER_UID}` ; fi || true

# Install base packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y ros-${ROS_DISTRO}-desktop ros-dev-tools python3-argcomplete
RUN apt-get install -y ros-${ROS_DISTRO}-ament-clang-format
COPY ./turtlebot3/install-${ROS_DISTRO}-turtlebot3-packages.sh /tmp/
RUN /tmp/install-${ROS_DISTRO}-turtlebot3-packages.sh
RUN apt-get install -y python3-pip

# Install packages for developing
COPY ./scripts/install_neovim.sh /tmp/
RUN /tmp/install_neovim.sh

RUN apt-get install -y build-essential git curl wget unzip p7zip-full lzma ninja-build
RUN apt-get install -y python3-venv python3-dev
RUN apt-get install -y python-is-python3 pipx less ripgrep fd-find colordiff tree vim source-highlight x11vnc
RUN apt-get install -y libopencv-contrib-dev
RUN apt-get install -y llvm clangd clang-format lld
RUN apt-get install -y usbutils gdb fzf

RUN apt-get install -y apt-transport-https ca-certificates gnupg lsb-release
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce-cli

RUN apt-get update && \
    apt-get install -y ca-certificates curl gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y nodejs

# setup for installed packages
RUN ln -s /usr/bin/fdfind /usr/bin/fd
RUN echo '' > /etc/bash.bashrc && \
    echo '# add local settings ---------------------------------' > /etc/bash.bashrc && \
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

RUN groupadd --gid ${DOCKER_GID} docker
RUN usermod -a -G docker ${USERNAME}
RUN groupadd --gid ${RENDER_GID} render
RUN usermod -a -G render ${USERNAME}

RUN usermod -a -G video ${USERNAME}

# Create history file
RUN mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R ${USERNAME} /commandhistory

ENV SHELL=/bin/bash

# RUN rm -rf /var/lib/apt/lists/*

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER ${USERNAME}
WORKDIR /home/${USERNAME}/ws

COPY ./scripts/set-prompt.sh /home/${USERNAME}/.set-prompt.sh
RUN mkdir /home/${USERNAME}/.local
RUN mkdir /home/${USERNAME}/.config

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/${USERNAME}/.bashrc
RUN echo "if [[ -f /usr/share/gazebo/setup.bash ]] ; then . /usr/share/gazebo/setup.bash; fi" >> /home/${USERNAME}/.bashrc
RUN echo "if [[ -f /usr/share/bash-completion/completions/git ]] ; then .  /usr/share/bash-completion/completions/git; fi" >> /home/${USERNAME}/.bashrc
RUN echo "export GAZEBO_MODEL_PATH=\${GAZEBO_MODEL_PATH}:/opt/ros/${ROS_DISTRO}/share/turtlebot3_gazebo/models" >> /home/${USERNAME}/.bashrc
RUN echo "export TURTLEBOT3_MODEL=burger" >> /home/${USERNAME}/.bashrc
RUN echo "export HISTFILE=/commandhistory/.bash_history" >> /home/${USERNAME}/.bashrc
RUN echo "export LESSOPEN=\"| /usr/share/source-highlight/src-hilite-lesspipe.sh %s\"" >> /home/${USERNAME}/.bashrc
RUN echo "export LESS=\" -R \"" >> /home/${USERNAME}/.bashrc
RUN echo "export TZ=${TZ}" >> /home/${USERNAME}/.bashrc
RUN echo "export PATH=/home/${USERNAME}/bin:/home/${USERNAME}/.local/bin:/home/${USERNAME}/.cargo/bin:\${PATH}" >> /home/${USERNAME}/.bashrc
RUN echo "export PYTHONPATH=\${PYTHONPATH}:/home/ros/ws/src/hats_ros2_common/hats_bridge_adapter" >> /home/${USERNAME}/.bashrc
RUN echo "source /etc/bash_completion.d/git-prompt" >> /home/${USERNAME}/.bashrc
RUN echo "source ~/.set-prompt.sh" >> /home/${USERNAME}/.bashrc
RUN echo "alias vi=nvim" >> /home/${USERNAME}/.bashrc

COPY ./scripts/install_python_utils.sh /tmp/
RUN USER=${USERNAME} /tmp/install_python_utils.sh

COPY ./scripts/local_setup.sh /tmp/
RUN /tmp/local_setup.sh

CMD ["/bin/bash"]
