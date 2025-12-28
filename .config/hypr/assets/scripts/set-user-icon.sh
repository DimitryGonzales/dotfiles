#!/usr/bin/env bash

export USER_ICON_DIRECTORY="$HOME/.config/hypr/assets"

# Check if input is a JPG file
if [[ ! -f "$1" ]] || [[ $(file -b --mime-type "$1") != "image/jpeg" ]]; then
    printf "[ERROR] Input isn't a JPG file!\n" >&2
    exit 1
fi

# Display preview
if command -v chafa &> /dev/null; then
    printf "New user icon:\n"
    chafa -s 25x "$1" < /dev/null

    read -rp "Apply it? [Y/n] " APPLY
    APPLY=${APPLY,,};
    if [[ "$APPLY" == "n" ]]; then
        printf "[ALERT] User canceled user icon change!\n"
        exit 0
    fi
else
    printf "[ALERT] Unable to display preview, chafa not found! Applying without preview...\n"
fi

# Backup existing user icon
if [[ -f "$USER_ICON_DIRECTORY/user-icon.jpg" ]]; then
    if ! mv "$USER_ICON_DIRECTORY/user-icon.jpg" "$USER_ICON_DIRECTORY/user-icon.jpg.bak"; then
        printf "[ERROR] Failed to backup existing user icon!\n" >&2
        exit 1
    fi
    printf "Backed up existing user icon.\n"
else
    printf "[ALERT] No existing user icon found! Skipping backup...\n"
fi

# Copy new user icon
if ! cp "$1" "$USER_ICON_DIRECTORY/user-icon.jpg"; then
    printf "[ERROR] Failed to copy new user icon!\n" >&2

    if [[ -f "$USER_ICON_DIRECTORY/user-icon.jpg.bak" ]]; then
        if mv -v "$USER_ICON_DIRECTORY/user-icon.jpg.bak" "$USER_ICON_DIRECTORY/user-icon.jpg"; then
            printf "Undid user icon backup.\n"
        else
            printf "[ERROR] Failed to undo user icon backup!\n" >&2
        fi
    fi

    exit 1
fi
printf "Copied new user icon.\n"

# Restart/Start waybar
if command -v waybar &> /dev/null; then
    if pkill -SIGUSR2 waybar; then
        printf "Restarted waybar.\n"
    elif (waybar &> /dev/null &); then
        printf "Started waybar.\n"
    else
        printf "[ALERT] Failed to restart/start waybar!\n"
    fi
fi
