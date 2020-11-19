#!/usr/bin/env zsh
set -x
IFS=$'\n'
setopt sh_word_split

# Packages installed from Brew.
BREW_PACKAGES="
ack
awscli
colordiff
colortail
exa
graphviz
grc
htop
imagemagick
jq
neovim
p7zip
pandoc
pipenv
python
rclone
testdisk
tldr
tree
unrar
wget
"

# Packages to install by the way of Brew's casks.
CASK_PACKAGES="
chromium
darktable
docker
dropbox
fork
gimp
google-backup-and-sync
google-cloud-sdk
google-drive-file-stream
iina
java
macdown
mactex
slack
raspberry-pi-imager
textmate
tor-browser
"

# Python packages to install from PyPi.
PYTHON_PACKAGES="
howdoi
jupyter
meta-package-manager
neovim
poetry
pycodestyle
pydocstyle
pygments
pylint
pytest
pytest-cov
pytest-sugar
setuptools
tox
wheel
yapf
