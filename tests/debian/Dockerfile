FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

# Run all apt-get commands as root
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sudo=1.9.9-1 \
    curl=7.74.0-1.3+deb11u1 \
    file=1:5.39-3 \
    git=1:2.30.2-1 \
    zsh=5.8-6+deb11u1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

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

# Add a HEALTHCHECK instruction
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD curl -f http://localhost/ || exit 1