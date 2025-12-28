#!/usr/bin/env bash

printf "GO MAKE A NEW AND BETTER THEME SCRIPT!!!\n"
exit 0

shopt -s nullglob
shopt -s dotglob

# Define themes directory
THEMES_DIRECTORY=~/themes

# Choose themes directory and select theme
while true; do
    clear

    printf "Current themes directory: '%s'\n\n" "$THEMES_DIRECTORY"

    read -r -p "Do you want to change it? [y/N]: " BUFFER
    BUFFER=${BUFFER,,}
    BUFFER=${BUFFER:-"n"}

    if [[ "$BUFFER" = "y" ]]; then
        clear

        while true; do
            read -r -p "Enter new themes directory: " THEMES_DIRECTORY

            if [[ -d "$THEMES_DIRECTORY" ]]; then
                break
            else
                clear
                printf "Invalid directory!\n\n"
            fi
        done
    fi

    THEME=$(find "$THEMES_DIRECTORY" -mindepth 1 -maxdepth 1 -type d | fzf --delimiter=/ --with-nth=-1 --preview "eza -Ta {}")

    if [[ -n "$THEME" && -d "$THEME" ]]; then
        THEME_FILES=("$THEME"/*)

        if [[ "${#THEME_FILES[@]}" -gt 0 ]]; then
            printf "Selected theme files:\n\n"

            eza -Ta "$THEME"; echo

            read -r -p "Do you want to apply it? [Y/n]: " BUFFER
            BUFFER=${BUFFER,,}
            BUFFER=${BUFFER:-"y"}

            if [[ "$BUFFER" = "y" ]]; then
                break
            fi
        fi
    fi
done

# Apply theme
clear

printf "Copying files from '%s' to '%s'...\n" "$THEME" "$HOME"

if rsync -av -hh --progress --exclude="post_hook.sh" "$THEME/" "$HOME"; then
    printf "Files copied successfully!\n\n"
else
    printf "Failed to copy all files. Some changes may have been done.\n\n"
fi

# Post-hooks
if [[ -f "$THEME/post_hook.sh" ]]; then
    if "$THEME/post_hook.sh"; then
        printf "Post-hook '%s' executed successfully!\n\n" "$THEME/post_hook.sh"
    else
        printf "Failed to execute post-hook '%s'.\n\n" "$THEME/post_hook.sh"
    fi
else
    printf "No post-hook file.\n\n"
fi

if command -v waybar > /dev/null; then
    if pkill -SIGUSR2 waybar; then
        printf "Waybar restarted successfully!\n\n"
    else
        printf "Failed to restart waybar.\n\n"
    fi
else
    printf "Waybar is not installed.\n\n"
fi

if command -v waypaper > /dev/null; then
    if waypaper > /dev/null; then
        printf "Waypaper executed successfully!\n\n"
    else
        printf "Failed to execute waypaper.\n\n"
    fi
else
    printf "Waypaper is not installed.\n\n"
fi
