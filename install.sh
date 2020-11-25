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

# htop-osx requires root privileges to correctly display all running processes.
sudo chown root:wheel "$(brew --prefix)/bin/htop"
sudo chmod u+s "$(brew --prefix)/bin/htop"

######### Mac App Store packages #########

# Install Mac App Store CLI and upgrade all apps.
brew install mas
mas upgrade

# Remove Applications
sudo rm -rf /Applications/GarageBand.app
sudo rm -rf /Applications/iMovie.app

# Install Applications
mas lucky "Keynote"
mas lucky "Numbers"
mas lucky "Pages"
mas lucky "Final Cut Pro"
mas lucky "Logic Pro"
mas lucky "MainStage"
#mas lucky "Motion"

# Open apps so I'll not forget to login
open -a Dropbox

# Install QuickLooks plugins
# Source: https://github.com/sindresorhus/quick-look-plugins
brew cask install epubquicklook
brew cask install qlcolorcode
brew cask install qlimagesize
brew cask install qlmarkdown
brew cask install qlstephen
brew cask install qlvideo
brew cask install quicklook-json
brew cask install suspicious-package
qlmanage -r

# Clean things up.
brew cleanup
brew services cleanup

# Use latest pip.
python -m pip install --upgrade pip

# Install & upgrade all global python modules
for p in $PYTHON_PACKAGES
do
	echo "Installing python package $p"
	python -m pip install --upgrade "$p"
done

# create pyenv virtualenvironments for neovim 
# https://github.com/pyenv/pyenv/issues/1643
PYTHON_CONFIGURE_OPTS="--with-openssl=$(brew --prefix openssl)" \
CFLAGS="-I$(brew --prefix zlib)/include -I$(brew --prefix sqlite)/include -I$(brew --prefix bzip2)/include" \
LDFLAGS="-L$(brew --prefix zlib)/lib -L$(brew --prefix sqlite)/lib -L$(brew --prefix bzip2)/lib" \
pyenv install --patch 3.8.3 <<(curl -sSL https://github.com/python/cpython/commit/8ea6353.patch\?full_index\=1)

pyenv virtualenv 3.8.3 neovim3

pyenv install 2.7.15
pyenv virtualenv 2.7.15 neovim

# neovim node.js provider
sudo npm install -g neovim
#yarn global add neovim #if you use yarn

# neovim Ruby provider
sudo gem install neovim  # to ensure the neovim RubyGem is installed
gem environment     # to ensure the gem bin directory is in the PATH

# Generate pip and poetry completion.
# TODO https://github.com/pypa/pipenv/issues/442
python -m pip completion --zsh > ~/.zfunc/_pip
poetry completions zsh > ~/.zfunc/_poetry
_MPM_COMPLETE=source_zsh mpm > ~/.zfunc/_mpm

# Force Neovim plugin upgrades
nvim -c "try | call dein#update() | finally | qall! | endtry"

# Install zinit https://github.com/zdharma/zinit#zinit
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# Fix "zsh compinit: insecure directories" error.
sudo chown -R $(whoami) /usr/local/share/zsh /usr/local/share/zsh/site-functions
chmod u+w /usr/local/share/zsh /usr/local/share/zsh/site-functions

# Force zinit self-upgrade.
zinit self-update
zinit update

# install powerline fonts 
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts/ 
./install.sh 
rm -rf fonts

# Configure everything.
#source ./macos-config.sh

