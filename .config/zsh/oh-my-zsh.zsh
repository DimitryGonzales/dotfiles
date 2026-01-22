# Oh My Zsh directory (must be at the start)
export ZSH="/usr/share/oh-my-zsh"

# Command correction
ENABLE_CORRECTION="true"

# Plugins
plugins=(
    aliases
    bgnotify
    colored-man-pages
    emoji
    extract
    fancy-ctrl-z
    git
    qrcode
    safe-paste
    sudo
    universalarchive
)

# Prompt
autoload -U promptinit; promptinit
prompt pure

# Oh My Zsh (must be at the end)
source $ZSH/oh-my-zsh.sh
