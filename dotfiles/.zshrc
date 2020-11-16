# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

###############################################################################
# Zsh Options
###############################################################################
# Source: http://zsh.sourceforge.net/Doc/Release/Options.html

## Changing Directories
# If a command is issued that can't be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt auto_cd

## Completion
setopt complete_in_word
# Whenever a command completion is attempted, make sure the entire command path
# is hashed first.
setopt hash_list_all

## Expansion and Globbing
# Make globbing (filename generation) un-sensitive to case.
# Bug: zsh-autosuggestions doesn't respect that parameter: https://github.com/zsh-users/zsh-autosuggestions/issues/239
unsetopt case_glob
# In order to use #, ~ and ^ for filename generation grep word
# *~(*.gz|*.bz|*.bz2|*.zip|*.Z) -> searches for word not in compressed files
# don't forget to quote '^', '~' and '#'!
setopt extended_glob
# Lets files beginning with a . be matched without explicitly specifying the dot.
setopt glob_dots

## History
# Append history list to the history file; this is the default but we make sure
# because it's required for share_history.
setopt append_history
# Save each command's beginning timestamp and the duration to the history file.
setopt extended_history
# Expire duplicate entries first when trimming history.
setopt hist_expire_dups_first
# If a new command line being added to the history list duplicates an older
# one, the older command is removed from the list.
setopt hist_ignore_all_dups
# Remove superfluous blanks before recording entry.
setopt hist_reduce_blanks
# Don't execute immediately upon history expansion.
setopt hist_verify
# Import new commands from the history file also in other zsh-session.
setopt share_history

## Input/Output
# Turns on spelling correction for all arguments.
setopt correct_all
# Turns on interactive comments; comments begin with a #.
setopt interactive_comments

## Job Control
# Display PID when suspending processes as well.
setopt long_list_jobs
# Report the status of backgrounds jobs immediately.
setopt notify

## Shell Emulation
# Use zsh style word splitting.
unsetopt sh_word_split

## Zle
# Avoid beeps and visual bells.
unsetopt beep

###############################################################################
# Zsh Plugins
###############################################################################
zinit light zsh-users/zsh-completions

# Load custom completion.
fpath=( ~/.zfunc "${fpath[@]}" )

# Initialize completion.
# See: https://github.com/Aloxaf/fzf-tab/issues/61
zpcompinit; zpcdreplay

# Configure fzf and its Zsh integration.
# Source: https://mike.place/2017/fzf-fd/
export FZF_DEFAULT_COMMAND="fd --one-file-system --type f --hidden . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --one-file-system --type d --hidden --exclude .git . $HOME"
zinit light Aloxaf/fzf-tab

zinit light zdharma/fast-syntax-highlighting

zinit light zsh-users/zsh-history-substring-search

# Autosuggestion plugin config.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
#ZSH_AUTOSUGGEST_MANUAL_REBIND=1
zinit light zsh-users/zsh-autosuggestions

zinit light darvid/zsh-poetry

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

###############################################################################
# Prompt
###############################################################################
# Set user & root prompt
export SUDO_PS1='\[\e[31m\]\u\[\e[37m\]:\[\e[33m\]\w\[\e[31m\]\$\[\033[00m\] '

