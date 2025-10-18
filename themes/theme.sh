#!/usr/bin/env bash

shopt -s nullglob
shopt -s dotglob

clear

# Define themes directory
THEMES_DIRECTORY=~/themes

printf "Current themes directory: '%s'\n\n" "$THEMES_DIRECTORY"

read -r -p "Do you want to change it? (y/N) " BUFFER
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

# Select theme
while true; do
    clear

    THEME=$(find "$THEMES_DIRECTORY" -mindepth 1 -maxdepth 1 -type d | fzf --preview "eza -Ta {}")

    if ! [[ -z "$THEME" ]]; then
        THEME_FILES=("$THEME"/*)

        if ! [[ "${#THEME_FILES[@]}" -eq 0 ]]; then
            printf "Selected theme files:\n\n"

            eza -Ta "$THEME"; echo

            read -r -p "Do you want to apply it? (Y/n) " BUFFER
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

if cp -rv "${THEME_FILES[@]}" "$HOME"; then
    printf "\nFiles copied successfully!\n\n"
else
    printf "\nFailed to copy all files, check errors above. Some changes may have been done.\n\n"
fi

# Select wallpaper and execute post-hooks
waypaper
