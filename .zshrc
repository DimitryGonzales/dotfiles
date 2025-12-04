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

# ZSH #
# Aliases
alias cp="cp --verbose -r"
alias mkdir="mkdir -p"

alias cat="bat"

alias ls="eza -lh --hyperlink --smart-group --time-style '+%d/%m/%Y %H:%M'"
alias lsa="eza -lah --hyperlink --smart-group --time-style '+%d/%m/%Y %H:%M'"

alias p="sudo pacman"
alias pc="paru -Sccd"
alias pu="sudo pacman -Syu && paru"

alias remi="sudo reflector --verbose --country Brazil --sort rate --save /etc/pacman.d/mirrorlist"

alias st="~/themes/theme.sh"
alias sw="matugen -v image"
