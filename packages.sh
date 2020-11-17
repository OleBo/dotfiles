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
bisq
db-browser-for-sqlite
disk-drill
dropbox
dupeguru
electrum
fork
gimp
google-drive-file-stream
iina
java
kap
macdown
netnewswire
tor-browser
"

# Python packages to install from PyPi.
PYTHON_PACKAGES="
howdoi
neovim
pycodestyle
pydocstyle
pygments
"
