#!/usr/bin/env zsh
set -x
IFS=$'\n'
setopt sh_word_split

# Packages installed from Brew.
BREW_PACKAGES="
ack
arpack
automakei
awscli
ctags
colordiff
colortail
exa
graphviz
grc
htop
imagemagick
jq
neovim
openssl
p7zip
pandoc
pipenv
pyenv
pyenv-virtualenv
python
rclone
readline
sqlite3
testdisk
tldr
tree
unrar
wget
xz
zlib
fzf
tmux
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
cufflinks
howdoi
jupyter
jupyterlab
meta-package-manager
neovim
notebook
numpy
pandas
plotly
poetry
pycodestyle
pydocstyle
pygments
pylint
pytest
pytest-cov
pytest-sugar
pytest_tornasync
setuptools
tox
voila
wheel
yapf
"
