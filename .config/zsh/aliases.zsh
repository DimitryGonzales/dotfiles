# cat to bat
alias cat="bat"

# File management
alias cp="cp -v"
alias mkdir="mkdir -p"
alias mv="mv -v"
alias rm="rm -v"

# ls to eza
alias ls="eza -lgh --hyperlink --group-directories-first"
alias lsa="eza -lagh --hyperlink --group-directories-first"

# Package management
alias clean="sudo rm -r /var/cache/pacman/pkg/download-* && paru -Sccd"
alias p="sudo pacman"
alias update="sudo reflector --verbose --country Brazil --sort rate --save /etc/pacman.d/mirrorlist && sudo pacman -Syu && paru -Sua"

# Scripts
alias theme="~/.config/hypr/scripts/theme.sh"
alias wallpaper="matugen -v image"
