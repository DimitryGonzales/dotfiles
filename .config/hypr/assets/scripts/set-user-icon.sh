#!/usr/bin/env bash

export USER_ICON_DIRECTORY="$HOME/.config/hypr/assets"

# Check if input is an image
if [[ $(file -b --mime-type "$1") != image/* ]]; then
    printf "[ERROR] Input isn't an image!\n" >&2
    exit 1
fi

# Check dependencies
missing_dependency="false"
dependencies=("chafa" "magick")
for item in "${dependencies[@]}"; do
    if ! command -v "$item" > /dev/null; then
        printf "[ERROR] '%s' isn't installed, install it to continue!\n" "$item" >&2
        missing_dependency="true"
    fi
done
[[ "$missing_dependency" == "true" ]] && exit 1

# Display preview
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

# Convert and/or copy new user icon
undo_backup="false"
if [[ $(file -b --mime-type "$1") != image/jpeg ]]; then
    if magick "$1" "$USER_ICON_DIRECTORY/user-icon.jpg"; then
        printf "Converted to JPEG and applied new user icon.\n"
    else
        printf "[ERROR] Failed to convert to JPEG and apply new user icon!\n"
        undo_backup="true"
    fi
else
    if cp "$1" "$USER_ICON_DIRECTORY/user-icon.jpg" > /dev/null; then
        printf "Applied new user icon\n"
    else
        printf "[ERROR] Failed to apply new user icon!\n" >&2
        undo_backup="true"
    fi
fi

# Undo backup if necessary
if [[ "$undo_backup" == "true" && -f "$USER_ICON_DIRECTORY/user-icon.jpg.bak" ]]; then
    if ! mv -v "$USER_ICON_DIRECTORY/user-icon.jpg.bak" "$USER_ICON_DIRECTORY/user-icon.jpg" > /dev/null; then
        printf "[ERROR] Failed to undo user icon backup!\n" >&2
        exit 1
    fi
    printf "Undid user icon backup.\n"
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
