FROM fedora:41

RUN dnf update -y && \
    dnf install -y \
    curl-7.85.0-1.fc41 \
    sudo-1.9.9-1.fc41 \
    sed-4.8-2.fc41 \
    findutils-4.8.0-1.fc41 \
    util-linux-user-2.37.2-1.fc41 \
    libxcrypt-compat-4.4.18-1.fc41 \
    shadow-utils-4.8.1-1.fc41 && \
    dnf clean all

RUN useradd -m -s /bin/sh -d /home/docker-qa docker-qa && \
    echo "docker-qa ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER docker-qa

COPY ./ /home/docker-qa/.dotfiles

WORKDIR /home/docker-qa

RUN DOTFILES_VERBOSE=true DOTFILES_NO_TTY=true .dotfiles/install

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD curl -f http://localhost/ || exit 1