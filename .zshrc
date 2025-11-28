# Oh My Zsh installation
export ZSH="/usr/share/oh-my-zsh"

# Oh My Zsh theme
ZSH_THEME="steeef"

# Oh My Zsh update frequency
zstyle ':omz:update' frequency 7

# Command correction
ENABLE_CORRECTION="true"

# Command execution time stamp shown in the history command output.
HIST_STAMPS="%d/%m/%Y"

# Oh my Zsh plugins
plugins=(
    aliases
    bgnotify
    colored-man-pages
    emoji
    fancy-ctrl-z
    git
)

# Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Aliases
alias cp="cp --verbose -r"
alias mkdir="mkdir -p"

alias cat="bat"

alias ls="eza -lh --hyperlink --smart-group --time-style '+%d/%m/%Y %H:%M'"
alias lsa="eza -lah --hyperlink --smart-group --time-style '+%d/%m/%Y %H:%M'"

alias p="sudo pacman"
alias pu="sudo pacman -Syu && paru"

alias pcc="paru -Sccd"
alias remi="sudo reflector --verbose --country Brazil --sort rate --save /etc/pacman.d/mirrorlist"
alias sw="matugen -v image"
alias st="~/themes/theme.sh"
