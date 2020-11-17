#!/usr/bin/env zsh
set -x
IFS=$'\n'
setopt sh_word_split

# Packages installed from Brew.
BREW_PACKAGES="
colordiff
grc
htop
neovim
python
wget
"

# Packages to install by the way of Brew's casks.
CASK_PACKAGES="
tor-browser
"

# Python packages to install from PyPi.
PYTHON_PACKAGES="
howdoi
neovim
"
