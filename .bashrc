# Enable the subsequent settings only in interactive sessions
case $- in
    *i*) ;;
      *) return;;
esac

# OSH installation.
export OSH=/usr/share/oh-my-bash

# Language environment
export LANG=en_US.UTF-8

# Disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Command execution time stamp shown in the history command output
HIST_STAMPS='[dd.mm.yyyy] + [time] with colors'

# Aliases
aliases=(
    general
)

# Plugins
plugins=(
    colored-man-pages
    sudo
)

# OSH theme
OSH_THEME="sexy"

# Bash cache directory
BASH_CACHE_DIR=$HOME/.cache/oh-my-bash
if [[ ! -d $BASH_CACHE_DIR ]]; then
    mkdir $BASH_CACHE_DIR
fi

# OSH
source "$OSH"/oh-my-bash.sh

# Aliases
alias cp="cp --verbose -r"
alias mkdir="mkdir -p"

alias cat="bat"

alias ls="eza -lh"
alias lsa="eza -lha"

alias p="sudo pacman"
alias pu="sudo pacman -Syu && paru"

alias pcc="paru -Sccd"
alias remi="sudo reflector --verbose --country Brazil --sort rate --save /etc/pacman.d/mirrorlist"
alias sw="matugen -v image"
