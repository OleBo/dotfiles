FROM registry.access.redhat.com/ubi8/ubi:latest

# Install necessary packages
RUN yum update -y && \
    yum install -y \
    curl \
    sudo \
    sed \
    findutils \
    util-linux-user \
    shadow-utils

# Create a new user and set up sudo permissions
RUN useradd -m -s /bin/sh -d /home/docker-qa docker-qa && \
    echo "docker-qa ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to the new user
USER docker-qa

# Copy the dotfiles to the user's home directory
COPY ./ /home/docker-qa/.dotfiles

# Set the working directory
WORKDIR /home/docker-qa

# Run the dotfiles installation script
RUN DOTFILES_VERBOSE=true DOTFILES_NO_TTY=true .dotfiles/install
