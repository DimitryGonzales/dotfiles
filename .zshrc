# OH MY ZSH #
# Installation directory
export ZSH="/usr/share/oh-my-zsh"

# Theme
ZSH_THEME="steeef"

# Update frequency
zstyle ':omz:update' frequency 7

# Command correction
ENABLE_CORRECTION="true"

# Command execution time stamp shown in the history command output.
HIST_STAMPS="%d/%m/%Y"

# Plugins
plugins=(
    aliases
    bgnotify
    colored-man-pages
    emoji
    fancy-ctrl-z
    git
)

# Installation
source $ZSH/oh-my-zsh.sh

# ALIASES #
# cat to bat
alias cat="bat"

# File management
alias cp="cp -v"
alias mkdir="mkdir -p"
alias mv="mv -v"
alias rm="rm -v"

# ls to eza
alias ls="eza -lh --hyperlink --smart-group --time-style '+%d/%m/%Y %H:%M'"
alias lsa="eza -lah --hyperlink --smart-group --time-style '+%d/%m/%Y %H:%M'"

# Package management
alias cleanpp="paru -Sccd"
alias p="sudo pacman"
alias remi="sudo reflector --verbose --country Brazil --sort rate --save /etc/pacman.d/mirrorlist"
alias update="remi && p -Syu && paru -Sua"

# Scripts
alias set-theme="~/themes/theme.sh"
alias set-user-icon="~/.config/hypr/assets/scripts/set-user-icon.sh"
alias set-wallpaper="matugen -v image"
