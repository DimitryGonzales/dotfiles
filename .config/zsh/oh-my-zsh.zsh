# Oh My Zsh directory (must be at the start)
export ZSH="/usr/share/oh-my-zsh"

# Command correction
ENABLE_CORRECTION="true"

# Plugins
plugins=(
    colored-man-pages
    extract
    fancy-ctrl-z
    qrcode
    safe-paste
    sudo
    universalarchive
)

# Prompt(pure)
autoload -U promptinit; promptinit
prompt pure

# Prompt: no newline at the start
print() {
    [[ $# -eq 0 && ${funcstack[-1]} = prompt_pure_precmd ]] || builtin print "$@"
}

prompt_needs_newline=false
precmd() {
    if [[ "$prompt_needs_newline" == true ]]; then
        echo
    fi
    prompt_needs_newline=true
}

clear() {
    prompt_needs_newline=false
    command clear
}

# Oh My Zsh (must be at the end)
source $ZSH/oh-my-zsh.sh
