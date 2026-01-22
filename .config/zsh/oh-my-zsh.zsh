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

PROMPT_NEEDS_NEWLINE=false
precmd() {
    if [[ "$PROMPT_NEEDS_NEWLINE" == true ]]; then
        echo
    fi
    PROMPT_NEEDS_NEWLINE=true
}

clear() {
    PROMPT_NEEDS_NEWLINE=false
    command clear
}

# Oh My Zsh (must be at the end)
source $ZSH/oh-my-zsh.sh
