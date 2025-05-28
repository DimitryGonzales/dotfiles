#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '


# Personal Config

# Neofetch
neofetch --chafa ~/sources/neofetch/gruvbox-dark/gruvbox-dark.png --size 400px

# Aliases
alias refresh-mirrors='sudo reflector --verbose --country Brazil --sort rate --save /etc/pacman.d/mirrorlist'