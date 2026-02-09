#!/usr/bin/env bash

# Colors
BLACK="\e[0;30m"
RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
BLUE="\e[0;34m"
MAGENTA="\e[0;35m"
CYAN="\e[0;36m"
WHITE="\e[0;37m"
RESET="\e[0m"

abort() {
    printf "%bExecution aborted!%b\n" "$RED" "$RESET" >&2
    exit 1
}

# Shell options
shopt -s dotglob extglob nullglob

THEMES_DIRECTORY="$HOME/Themes"

# Check dependencies
DEPENDENCIES=(
    "chafa"
    "eza"
    "fzf"
)

missing_dependency="false"
for item in "${DEPENDENCIES[@]}"; do
    if ! command -v "$item" > /dev/null; then
        printf "%b%s isn't installed!%b\n" "$RED" "$item" "$RESET" >&2
        missing_dependency="true"
    fi
done
[[ "$missing_dependency" == "true" ]] && abort

# Select theme
while true; do
    THEME=$(find "$THEMES_DIRECTORY" -mindepth 1 -maxdepth 1 -type d | fzf --delimiter=/ --with-nth=-1 --preview 'eza -Ta --color=always {} && img=$(find {} -maxdepth 1 -iname "preview.*" | head -1) && [[ -n "$img" ]] && echo && chafa -s 25x "$img"')
    [[ -z "$THEME" ]] && abort

    THEME_FILES=("$THEME"/!(post-hook.sh|preview.*))
    [[ "${#THEME_FILES[@]}" -gt 0 ]] && break

    printf "%bNo valid theme files.%b\n" "$YELLOW" "$RESET"
    sleep 2
done

# Apply theme
if ! cp -r "${THEME_FILES[@]}" "$HOME" > /dev/null; then
    printf "%bFailed to apply theme!%b\n" "$RED" "$RESET" >&2
    abort
fi
printf "%bApplied theme successfully.%b\n" "$GREEN" "$RESET"

# Execute post-hook
if [[ -f "$THEME/post-hook.sh" ]]; then
    if "$THEME/post-hook.sh" > /dev/null; then
        printf "%bExecuted post-hook successfully.%b\n" "$GREEN" "$RESET"
    else
        printf "%bFailed to execute post-hook!%b\n" "$RED" "$RESET" >&2
    fi
fi

# Restart/Start swaync
if pgrep swaync > /dev/null; then
    if swaync-client -R > /dev/null && swaync-client -rs > /dev/null; then
        printf "%bRestarted swaync.%b\n" "$GREEN" "$RESET"
    elif nohup swaync > /dev/null 2>&1 & disown; then
        printf "%bStarted swaync.%b\n" "$GREEN" "$RESET"
    else
        printf "%bFailed to restart/start swaync!%b\n" "$RED" "$RESET" >&2
    fi
fi

# Restart/Start waybar
if pgrep waybar > /dev/null; then
    if pkill -SIGUSR2 waybar > /dev/null; then
        printf "%bRestarted waybar.%b\n" "$GREEN" "$RESET"
    elif nohup waybar > /dev/null 2>&1 & disown; then
        printf "%bStarted waybar.%b\n" "$GREEN" "$RESET"
    else
        printf "%bFailed to restart/start waybar!%b\n" "$RED" "$RESET" >&2
    fi
fi
