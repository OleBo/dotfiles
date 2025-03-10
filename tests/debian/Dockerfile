FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

# Run all apt-get commands as root
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    sudo \
    curl \
    iproute2 \
    file \
    git \
    zsh

# Create a new user and set up sudo permissions
RUN useradd -m -s /bin/zsh -d /home/docker-qa docker-qa && \
    echo "docker-qa ALL=NOPASSWD: ALL" >> /etc/sudoers

# Switch to the new user
USER docker-qa

# Copy the dotfiles to the user's home directory
COPY --chown=docker-qa:docker-qa ./ /home/docker-qa/.dotfiles

# Set the working directory
WORKDIR /home/docker-qa

# Run the dotfiles installation script
RUN DOTFILES_VERBOSE=true DOTFILES_NO_TTY=true .dotfiles/install
