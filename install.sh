#!/usr/bin/env zsh
# Print commands and their arguments as they are executed. (turn off: set +x)
set -x

# Detect platform.
if [ "$(uname -s)" != "Darwin" ]; then
	echo "These dotfiles only targets macOS."
	exit 1
fi

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check if System Integrity Protection (SIP) is Enabled on Mac
# SIP locks down certain Mac OS system folders to prevent modification, 
# execution, and deletion of critical system-level files on the Mac, 
# even with a root user account.
csrutil status | grep --quiet "disabled"
if [[ $? -ne 0 ]]; then
	echo "System Integrity Protection (SIP) is enabled."
else
	echo "System Integrity Protection (SIP) is disabled."
fi

######### Dotfiles install #########

DOT_FILES=("${(@f)$(find ./dotfiles -maxdepth 1 -not -path './dotfiles' -not -name '\.DS_Store')}")
for FILEPATH in $DOT_FILES
do
	SOURCE="${PWD}/$FILEPATH"
	TARGET="${HOME}/$(basename "${FILEPATH}")"
    # Link files
	if [ -e "${TARGET}" ] && [ ! -L "${TARGET}" ]; then
		mv "$TARGET" "$TARGET.dotfiles.bak"
		echo "$TARGET already exists. I replaced it and moved it to $TARGET.dotfiles.bak"
	fi
	ln -sf "${SOURCE}" "$(dirname "${TARGET}")"
done

######### System upgrades #########

# Update all macOS packages.
sudo softwareupdate -i -a

######### Brew install #########

# Check if homebrew is already installed
# This also install xcode command line tools
if test ! "$(command -v brew)"
then
    # Install Homebrew without prompting for user confirmation.
    # See: https://discourse.brew.sh/t/silent-automated-homebrew-install/3180
    CI=true ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
brew analytics off
brew update
brew upgrade

# Add Cask https://github.com/Homebrew/homebrew-cask/blob/master/USAGE.md
brew tap homebrew/cask

# Add drivers https://github.com/Homebrew/homebrew-cask-drivers
brew tap homebrew/cask-drivers

# Add services https://github.com/Homebrew/homebrew-services
brew tap homebrew/services

# Add fonts https://github.com/Homebrew/homebrew-cask-fonts
brew tap homebrew/cask-fonts

# Install XQuartz beforehand to support Linux-based GUI Apps.
brew cask install xquartz

# Load package lists to install.
source ./packages.sh

# Install brew packages.
for PACKAGE in $BREW_PACKAGES
do
	echo "Installing brew package $PACKAGE"
	brew install "$PACKAGE"
done

# Install cask packages.
for PACKAGE in $CASK_PACKAGES
do
	echo "Installing cask package $PACKAGE"
	brew cask install "$PACKAGE"
done