#!/usr/bin/env bash

shopt -s dotglob extglob nullglob

themes_directory="$HOME/Themes"

# Check if input is a directory
if [[ -n "$1" ]]; then
    if [[ ! -d "$1" ]];then
        printf "[ERROR] Input isn't a directory!\n" >&2
        exit 1
    fi
    themes_directory="$1"
fi

# Check dependencies
missing_dependency="false"
dependencies=("chafa" "eza" "fzf")
for item in "${dependencies[@]}"; do
    if ! command -v "$item" > /dev/null; then
        printf "[ERROR] '%s' isn't installed, install it to continue!\n" "$item" >&2
        missing_dependency="true"
    fi
done
[[ "$missing_dependency" == "true" ]] && exit 1

# Select directory
while true; do
    theme=$(find "$themes_directory" -mindepth 1 -maxdepth 1 -type d | fzf --delimiter=/ --with-nth=-1 --preview 'eza -Ta --color=always {} && img=$(find {} -maxdepth 1 -iname "preview.*" | head -1) && [ -n "$img" ] && echo && chafa -s 25x "$img"')
    if [[ -z "$theme" ]]; then
        printf "[ABORT] Execution canceled!\n"
        exit 0
    fi

    theme_files=("$theme"/!(post-hook.sh|preview.*))
    [[ "${#theme_files[@]}" -gt 0 ]] && break

    printf "[ALERT] No valid files in the directory! Restarting...\n"; sleep 2
done

# Copy directory files
if ! cp -r "${theme_files[@]}" "$HOME" > /dev/null; then
    printf "[ERROR] Failed to copy directory files!\n" >&2
    exit 1
fi
printf "Copied directory files.\n"

# Execute post-hook
if [[ -f "$theme/post-hook.sh" ]]; then
    if "$theme/post-hook.sh" > /dev/null; then
        printf "Executed 'post-hook.sh'.\n"
    else
        printf "[ALERT] Failed to execute 'post-hook.sh'!\n"
    fi
else
    printf "No existing 'post-hook.sh' file. Skipping post-hook execution...\n"
fi

# Restart/Start waybar
if command -v waybar > /dev/null; then
    if pkill -SIGUSR2 waybar > /dev/null; then
        printf "Restarted 'waybar'.\n"
    elif (waybar > /dev/null &); then
        printf "Started 'waybar'.\n"
    else
        printf "[ALERT] Failed to restart/start 'waybar'!\n"
    fi
else
    printf "'waybar' isn't installed. Skipping restart/start...\n"
fi

# Start waypaper
if command -v waypaper > /dev/null; then
    if (waypaper > /dev/null); then
        printf "Started 'waypaper'.\n"
    else
        printf "[ALERT] Failed to start 'waypaper'!\n"
    fi
else
    printf "'waypaper' isn't installed. Skipping start...\n"
fi
