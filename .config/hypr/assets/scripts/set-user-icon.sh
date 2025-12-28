#!/usr/bin/env bash

export USER_ICON_DIRECTORY="$HOME/.config/hypr/assets"

# Check if input is a JPG file
if [[ ! -f "$1" ]] || [[ $(file -b --mime-type "$1") != "image/jpeg" ]]; then
    printf "[ERROR] Input isn't a JPG file!\n" >&2
    exit 1
fi

# Display preview
if ! command -v chafa > /dev/null; then
    printf "[ERROR] 'chafa' isn't installed, install it to continue!\n" >&2
    exit 1
fi

if [[ -f "$USER_ICON_DIRECTORY/user-icon.jpg" ]]; then
    printf "Existing user icon:\n"
    chafa -s 25x "$USER_ICON_DIRECTORY/user-icon.jpg" < /dev/null
fi

printf "New user icon:\n"
chafa -s 25x "$1" < /dev/null

read -rp "Apply the change? [Y/n] " APPLY
APPLY=${APPLY,,};
if [[ "$APPLY" == "n" ]]; then
    printf "[ABORT] Execution canceled!\n"
    exit 0
fi

# Backup existing user icon
if [[ -f "$USER_ICON_DIRECTORY/user-icon.jpg" ]]; then
    if ! mv "$USER_ICON_DIRECTORY/user-icon.jpg" "$USER_ICON_DIRECTORY/user-icon.jpg.bak" > /dev/null; then
        printf "[ERROR] Failed to backup existing user icon!\n" >&2
        exit 1
    fi
    printf "Backed up existing user icon.\n"
else
    printf "No existing user icon found! Skipping backup...\n"
fi

# Copy new user icon
if ! cp "$1" "$USER_ICON_DIRECTORY/user-icon.jpg" > /dev/null; then
    printf "[ERROR] Failed to copy new user icon!\n" >&2

    if [[ -f "$USER_ICON_DIRECTORY/user-icon.jpg.bak" ]]; then
        if mv -v "$USER_ICON_DIRECTORY/user-icon.jpg.bak" "$USER_ICON_DIRECTORY/user-icon.jpg" > /dev/null; then
            printf "Undid user icon backup.\n"
        else
            printf "[ERROR] Failed to undo user icon backup!\n" >&2
        fi
    fi

    exit 1
fi
printf "Copied new user icon.\n"

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
