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
