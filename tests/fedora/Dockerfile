FROM fedora:latest

RUN dnf update -y && \
    dnf install -y \
    curl \
    sudo \
    sed \
    findutils \
    util-linux-user \
    libxcrypt-compat \
    shadow-utils

RUN useradd -m -s /bin/sh -d /home/docker-qa docker-qa  && \
    echo "docker-qa ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER docker-qa

COPY ./ /home/docker-qa/.dotfiles

WORKDIR /home/docker-qa

RUN DOTFILES_VERBOSE=true DOTFILES_NO_TTY=true .dotfiles/install
