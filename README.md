# Dotfiles 
## Instaled brew package
- ack: Search tool like grep, but optimized for programmers
https://beyondgrep.com/
$  ack --output='$. $_' '^Installing brew package' install.log
- awscli: Official Amazon AWS command-line interface
https://aws.amazon.com/cli/
$ aws configure
- colordiff: Color-highlighted diff(1) output
https://www.colordiff.org/
$ git diff ce81947 27f8d2e | colordiff
- colortail: Like tail(1), but with various colors for specified output
https://github.com/joakim666/colortail
colortail install.log TODO
- exa: Modern replacement for 'ls'
https://the.exa.website
$ exa --long --header --git
- graphviz: Graph visualization software from AT&T and Bell Labs
https://www.graphviz.org/
$ echo "digraph G {Hello->World}" | dot -Tpng > hello.png
- grc: Colorize logfiles and command output
https://korpus.juls.savba.sk/~garabik/software/grc.html
$ grc tail install.log
- htop: Improved top (interactive process viewer)
https://htop.dev/
$ htop -t
- imagemagick: Tools and libraries to manipulate images in many formats
https://www.imagemagick.org/
$ magick *.png image.jpg
- jq: Lightweight and flexible command-line JSON processor
https://stedolan.github.io/jq/
$ curl 'https://api.github.com/repos/olebo/dotfiles/commits?per_page=5' | jq '.[0] | {message: .commit.message, name: .commit.committer.name}'
- neovim: Ambitious Vim-fork focused on extensibility and agility
https://neovim.io/
$ nvim :Tutor
- p7zip: 7-Zip (high compression file archiver) implementation
https://p7zip.sourceforge.io/
$ 7z a archive.7z .
- pandoc: universal document converter
https://pandoc.org/installing.html
$ pandoc README.md
- python: python3 and setuptools in 
    - /usr/local/opt/python/libexec/bin
    - /usr/local/Cellar/python@3.9/3.9.0_1/bin/ 
    - /usr/local/Frameworks/Python.framework/Versions/3.9/bin/
- rclone: Rsync for cloud storage
https://rclone.org https://rclone.org/dropbox/ https://rclone.org/drive/
$ rclone config
$ rclone lsd dbremote:
$ rclone ls dbremote:
$ rclone copy . dbremote:backup
- testdisk: Powerful free data recovery utility
https://www.cgsecurity.org/wiki/TestDisk
- tldr: Simplified and community-driven man pages
https://tldr.sh
$ tldr rclone
- tree: Display directories as trees (with optional color/HTML output)
http://mama.indstate.edu/users/ice/tree/
$ tree .
- unrar: Extract, view, and test RAR archives
https://www.rarlab.com/
$ unrar x archive.rar 
- wget: Internet file retriever
https://www.gnu.org/software/wget
$ wget https://example.com/foo

## Install

1. First, you need a local copy of this project.

   If you're lucky and have `git` already installed on your machine, do:

        $ cd ~
        $ git clone --recursive https://github.com/olebo/dotfiles.git

   If you don't have `git` yet, fetch an archive of the repository:

        $ mkdir ~/dotfiles
        $ cd ~/dotfiles
        $ curl -fsSL https://github.com/olebo/dotfiles/tarball/main | tar --strip-components 1 -xvzf -

2. Now you can install the dotfiles on your system:

        $ cd ~/dotfiles
        $ ./install.sh 2>&1 | tee ./install.log
   Runs install.sh and send stdout/err to file install.log and terminal.

