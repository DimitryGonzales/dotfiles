# Oh My Zsh directory
export ZSH="/usr/share/oh-my-zsh"

# Update frequency
zstyle ':omz:update' frequency 7

# Theme
#ZSH_THEME="steeef"

# Prompt
autoload -U promptinit; promptinit
prompt pure

# Time stamp shown in the history command output.
HIST_STAMPS="%d/%m/%Y"

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

# Oh My Zsh
source $ZSH/oh-my-zsh.sh
