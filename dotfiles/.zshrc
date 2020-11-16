###############################################################################
# Neovim
###############################################################################
# Make Neovim the default editor
export EDITOR="nvim"

alias vim='nvim'
alias vi='nvim'
alias v="nvim"

###############################################################################
# Expends global searched path to look for brew-sourced utilities.
###############################################################################
# File where the list of path is cached.
PATH_CACHE="${HOME}/.path-env-cache"

# Force a cache refresh if file doesn't exist or older than 7 days.
# Source: https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-3109177
() {
    setopt extendedglob local_options
    if [[ ! -e ${PATH_CACHE} || -n ${PATH_CACHE}(#qN.md+7) ]]; then
        # Ordered list of path.
        PATH_LIST=(
            /usr/local/sbin
            $(brew --prefix coreutils)/libexec/gnubin
            $(brew --prefix grep)/libexec/gnubin
            $(brew --prefix findutils)/libexec/gnubin
            $(brew --prefix gnu-sed)/libexec/gnubin
            $(brew --prefix gnu-tar)/libexec/gnubin
            $(brew --prefix openssh)/bin
            $(brew --prefix curl)/bin
            $(brew --prefix python)/libexec/bin
        )
        print -rl -- ${PATH_LIST} > ${PATH_CACHE}
    fi
}

# Cache exists and has been refreshed in the last 24 hours: load it.
# Source: https://stackoverflow.com/a/41212803
for line in "${(@f)"$(<${PATH_CACHE})"}"
{
    # Prepend paths. Source: https://stackoverflow.com/a/9352979
    path[1,0]=${line}
}

###############################################################################
# File associations, i.e. suffix aliases
###############################################################################
# Source: https://thorsten-hans.com/5-types-of-zsh-aliases#suffix-aliases

alias -s {py,rst,toml,json}=nvim

###############################################################################
# Zinit
###############################################################################

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

###############################################################################
# Zsh Parameters
###############################################################################
# Source: http://zsh.sourceforge.net/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell

# Prefer US English and use UTF-8
LANG="en_US.UTF-8"
LC_ALL=$LANG

# Setting history length
HISTSIZE=999999
SAVEHIST=$HISTSIZE

# Make some commands not show up in history
HISTORY_IGNORE='(l|ls|ll|cd|cd ..|pwd|exit|date|history)'

# Get rid of extra empty space on the right.
# See: https://github.com/romkatv/powerlevel10k#extra-space-without-background-on-the-right-side-of-right-prompt
ZLE_RPROMPT_INDENT=0

# Binds Up and Down to a history search, backwards and forwards.
# Source: https://unix.stackexchange.com/a/97844
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

