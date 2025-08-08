# Text colors
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"
RESET="\033[0m"

# Status messages
ALERT="[${YELLOW}ALERT${RESET}]"
ERROR="[${RED}ERROR${RESET}]"
OK="[${BLUE}OK${RESET}]"
SCRIPT="[${MAGENTA}SCRIPT${RESET}]"
SUCCESS="[${GREEN}SUCCESS${RESET}]"

# Display message
log() {
    printf "$SCRIPT %b\n" "$*"
}

# Display section name
section() {
    local TITLE="$1"

    log "[${CYAN}$TITLE${RESET}]"
}

# Ask user to select an option
ask_user() {
    local num_options="$1"
    shift

    if (( $# != num_options * 2 )); then
        log "$ERROR Invalid arguments: expected $((num_options * 2)) option/command pairs, got $#."
        return 1
    fi

    log "Please choose an option:"
    for ((i=1; i<=num_options; i++)); do
        local idx=$(( (i - 1) * 2 + 1 ))
        local option_label="${!idx}"
        log "$i) $option_label"
    done

    while true; do
        log "Enter choice [1-$num_options]: "
        read -r choice

        if [[ "$choice" =~ ^[1-9][0-9]*$ ]] && (( choice >= 1 && choice <= num_options )); then
            local cmd_index=$(( (choice - 1) * 2 + 2 ))
            local cmd="${!cmd_index}"
            eval "$cmd"
            return 0
        else
            log "$ALERT Invalid choice, try again."
        fi
    done
}

# Authenticate with sudo
authenticate() {
    log "Authentication:"

    if sudo -v; then
        (sudo -v; while true; do sleep 60; sudo -n true; done) &
        SUDO_REFRESH_PID=$!
        trap 'kill $SUDO_REFRESH_PID 2>/dev/null' EXIT
        log "$SUCCESS Authenticated."
    else
        log "$ERROR Failed to authenticate."
        return 1
    fi

    return 0
}

# Change current directory
change_directory() {
    local DIRECTORY="$1"

    if cd "$DIRECTORY"; then
        log "$SUCCESS Directory changed to: '$DIRECTORY'." 
    else
        log "$ERROR Couldn't change directory to: '$DIRECTORY'."
        return 1
    fi

    return 0
}

## Check package existence
check_package() {
    local RESULT=0

    for PACKAGE in "$@"; do
        if sudo pacman -Q "$PACKAGE" &> /dev/null; then
            log "$OK Package is installed: '$PACKAGE'"
        else
            log "$ALERT Package is not installed: '$PACKAGE'"
            RESULT=1
        fi
    done
    
    return $RESULT
}

# Copy directories/files
copy() {
    local SOURCE="$1"
    local DESTINATION="$2"

    if sudo cp -r "$SOURCE" "$DESTINATION"; then
        log "$SUCCESS Copied: '$SOURCE' to '$DESTINATION'."
    else
        log "$ERROR Failed to copy: '$SOURCE' to '$DESTINATION'."
        return 1
    fi

    return 0
}

# Git clone repository
git_clone() {
    local URL="$1"

    if git clone "$URL"; then
        log "$SUCCESS Git cloned repository: '$URL'."
    else
        log "$ERROR Failed to git clone repository: '$URL'."
        return 1
    fi

    return 0
}

# Make directory
make_directory() {
    local DIRECTORY="$1"

    if [ -d "$DIRECTORY" ]; then
        log "$OK Directory already exists: '$DIRECTORY'."
    else
        if sudo mkdir -p "$DIRECTORY"; then
            log "$SUCCESS Created directory: '$DIRECTORY'."
        else
            log "$ERROR Failed to create directory: '$DIRECTORY'"
            return 1
        fi
    fi

    return 0
}

# Make package
make_package() {
    if makepkg -si; then
        log "$SUCCESS Made package."
    else
        log "$ERROR Failed to make package."
        return 1
    fi

    return 0
}

# Install package(s) with pacman
pacman_install() {
    local ALL_INSTALLED=0

    for PACKAGE in "$@"; do
        if sudo pacman -Q "$PACKAGE" &> /dev/null; then
            log "$OK Package is installed: '$PACKAGE'."
        else
            log "$ALERT Package is not installed: '$PACKAGE'."
            ALL_INSTALLED=1
        fi
    done

    if [ "$ALL_INSTALLED" == 0 ]; then
        log "$OK All packages from the official repository are already installed."  
    else
        if sudo pacman -S --needed "$@"; then
            log "$SUCCESS Installed all packages."
        else
            log "$ERROR Failed to install all packages."
            return 1
        fi
    fi

    return 0
}

# Install package(s) with paru
paru_install() {
    local ALL_INSTALLED=0

    for PACKAGE in "$@"; do
        if sudo paru -Q "$PACKAGE" &> /dev/null; then
            log "$OK Package is installed: '$PACKAGE'."
        else
            log "$ALERT Package is not installed: '$PACKAGE'."
            ALL_INSTALLED=1
        fi
    done

    if [ "$ALL_INSTALLED" == 0 ]; then
        log "$OK All packages from the AUR repository are already installed."  
    else
        if sudo paru -S --needed "$@"; then
            log "$SUCCESS Installed all packages."
        else
            log "$ERROR Failed to install all packages."
            return 1
        fi
    fi

    return 0
}

remove_directory() {
    local DIRECTORY="$1"

    if ! [ -d "$DIRECTORY" ]; then
        log "$OK Directory doesn't exists: '$DIRECTORY'."
    else
        if rm -rf "$DIRECTORY"; then
            log "$SUCCESS Removed directory: '$DIRECTORY'."
        else
            log "$ERROR Failed to remove directory: '$DIRECTORY'."
            return 1
        fi
    fi

    return 0
}
