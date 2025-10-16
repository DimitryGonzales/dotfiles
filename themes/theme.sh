#!/usr/bin/env bash

shopt -s nullglob
shopt -s dotglob

is_integer() {
    [[ $1 =~ ^[+-]?[0-9]+$ ]]
}

DIRECTORY="$HOME/themes/"

# Check directory
[[ "${DIRECTORY}" != */ ]] && DIRECTORY="${DIRECTORY}/"

if [[ -d "$DIRECTORY" ]]; then
    DIRECTORY_FOLDERS=("$DIRECTORY"*/)

    if [[ ${#DIRECTORY_FOLDERS[@]} -eq 0 ]]; then
        printf "No folders found inside directory: %s\n" "$DIRECTORY"
        exit 1
    fi
else
    printf "Directory doesn't exist: %s\n" "$DIRECTORY"
    exit 1
fi

# Get user selection
printf "Folder: '%s'\n\n" "$DIRECTORY"

while true; do
    printf "Available options:\n\n"

    i=1
    for folder in "${DIRECTORY_FOLDERS[@]}"; do
        name=$(basename "${folder%/}")
        printf "%i) %s\n" "$i" "$name"
        ((i++))
    done

    echo; read -r -p "Selection: " SELECTED_FOLDER_INPUT

    if ! is_integer "$SELECTED_FOLDER_INPUT"; then
        clear
        printf "Selection needs to be an integer!\n\n"
        continue
    else
        if [[ $SELECTED_FOLDER_INPUT -le 0 ]]; then
            clear
            printf "Selection can't be less than or equal to 0!\n\n"
            continue
        elif [[ $SELECTED_FOLDER_INPUT -gt ${#DIRECTORY_FOLDERS[@]} ]]; then
            clear
            printf "Selection can't be greater than the number of options!\n\n"
            continue
        fi
    fi

    break
done

SELECTED_FOLDER="${DIRECTORY_FOLDERS[$SELECTED_FOLDER_INPUT-1]}"

[[ "${SELECTED_FOLDER}" != */ ]] && SELECTED_FOLDER="${SELECTED_FOLDER}/"

clear

# Display folder tree
printf "Folder: '%s'\n\n" "$SELECTED_FOLDER"

printf "Tree:\n"

FOLDER_CONTENTS=("${SELECTED_FOLDER}"*)

if [[ ${#FOLDER_CONTENTS[@]} -eq 0 ]]; then
    printf "The folder is empty!\n"
    exit 1
fi

for item in "${FOLDER_CONTENTS[@]}"; do
    name=$(basename "${item%/}")

    if [[ -d "$item" ]]; then
        printf -- "- %s/\n" "$name"

        [[ "$item" != */ ]] && item="${item}/"

        item_contents=("$item"*)

        for item_contents_item in "${item_contents[@]}"; do
            name=$(basename "${item_contents_item%/}")

            if [[ -d "$item_contents_item" ]]; then
                printf -- "  - %s/\n" "$name"
            else
                printf -- "  - %s\n" "$name"
            fi
        done
    else
        printf -- "- %s\n" "$name"
    fi
done

echo; read -r -p "Copy everything to '$HOME'? (Y/n) " COPY_EVERYTHING

COPY_EVERYTHING=${COPY_EVERYTHING:-"y"}
COPY_EVERYTHING=${COPY_EVERYTHING,,}

if [[ "$COPY_EVERYTHING" = "y" ]]; then
    # TODO
    # - Copy files
else
    exit 0
fi
