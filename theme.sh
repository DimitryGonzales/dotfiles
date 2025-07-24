#!/usr/bin/env bash

# Theme Switcher #


# Variables #

## Colors
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"
RESET="\033[0m"

## Messages
ALERT="[${YELLOW}ALERT${RESET}]"
ERROR="[${RED}ERROR${RESET}]"
OK="[${BLUE}OK${RESET}]"
SCRIPT="[${MAGENTA}SCRIPT${RESET}]"
SUCCESS="[${GREEN}SUCCESS${RESET}]"


# Functions #

## Display message
log() {
    printf "$SCRIPT %b\n" "$*"
}

## Apply wallpaper with hyprpaper
apply_wallpaper() {
    local WALLPAPER="$1"

    if hyprctl hyprpaper reload ,"$WALLPAPER" > /dev/null; then
        log "$SUCCESS Applied wallpaper: '$WALLPAPER'"
        return 0
    else
        log "$ERROR Failed to apply wallpaper(must be a png): '$WALLPAPER', check errors above"
        return 1
    fi
}

## Ask user to select an option
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

## Check directory existence
check_directory() {
    local DIRECTORY="$1"

    if [ -d "$DIRECTORY" ]; then
        log "$OK Directory already exists: '$DIRECTORY'"
        return 0
    else
        log "$ALERT Directory doesn't exists (creating...): '$DIRECTORY'"

        if mkdir -p "$DIRECTORY"; then
            log "$SUCCESS Created directory: '%s'\n" "$DIRECTORY"
            return 0
        else
            log "$ERROR Failed to create directory: '$DIRECTORY', check errors above"
            return 1
        fi
    fi
}

## Check json file existence
check_json() {
    local FILE="$1"

    if [ -f "$FILE" ]; then
        log "$OK JSON file already exists: $FILE"
        return 0
    else
        if echo {} > "$FILE"; then
            log "$SUCCESS Created empty JSON file: '$FILE'"
            return 0
        else
            log "$ERROR Failed to create empty JSON file: '$FILE', check errors above"
            return 1
        fi
    fi
}

## Copy something to a directory
copy() {
    local FILE="$1"
    local DIRECTORY="$2"

    check_directory "$DIRECTORY"

    if cp -r "$FILE" "$DIRECTORY"; then
        log "$SUCCESS Copied: '$FILE' to '$DIRECTORY'"
        return 0
    else
        log "$ERROR Failed to copy: '$FILE' to '$DIRECTORY', check errors above"
        return 1
    fi
}

## Edit an option inside a json file
edit_option_in_json() {
    local FILE="$1"
    local OPTION="$2"
    local VALUE="$3"

    check_json "$FILE"

    if grep -q "\"$OPTION\"" "$FILE"; then
        local CURRENT_VALUE
        CURRENT_VALUE=$(grep "\"$OPTION\"" "$FILE" | sed -E 's/.*"'$OPTION'":[[:space:]]*"(.*)".*/\1/')

        if [[ "$CURRENT_VALUE" == "$VALUE" ]]; then
            log "$OK '$OPTION' is already set to: '$VALUE'"
            return 0
        else
            if sed -i 's/\("'"$OPTION"'"[[:space:]]*:[[:space:]]*"\)[^"]*\("\)/\1'"$VALUE"'\2/' "$FILE"; then
                log "$SUCCESS Updated '$OPTION' to: '$VALUE'"
                return 0
            else
                log "$ERROR Failed to update '$OPTION' to: '$VALUE'"
                return 1
            fi
        fi
    else
        if sed -i '$i\  "'"$OPTION"'": "'"$VALUE"'",' "$FILE"; then
            log "$SUCCESS Inserted: '$OPTION: $VALUE'"
            return 0
        else
            log "$ERROR Failed to insert '$OPTION: $VALUE'"
            return 1
        fi
    fi
}

## Restart an app
restart_app() {
    local APP="$1"

    if pgrep -x "$APP" > /dev/null; then
        log "$OK App is already running (needs restart): '$APP'"

        if pkill "$APP" && hyprctl dispatch exec "$APP" > /dev/null; then
            sleep 1
            log "$SUCCESS Restarted app: '$APP'"
            return 0
        else
            log "$ERROR Failed to restart app: '$APP', check errors above"
            return 1
        fi
    else
        log "$ALERT App is not running (starting...): '$APP'"

        if hyprctl dispatch exec "$APP" > /dev/null; then
            sleep 1
            log "$SUCESS Started app: '$APP'"
            return 0
        else
            log "$ERROR Failed to start app: '$APP', check errors above"
            return 1
        fi
    fi
}

## Display section name
section() {
    local TITLE="$1"

    log "[${CYAN}$TITLE${RESET}]"
}

## Set the theme used by GTK apps
set_gtk_theme() {
    local ICON_THEME="$1"
    local THEME="$2"

    if gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"; then
        log "$SUCCESS Set GTK icon theme to: '$ICON_THEME'"
    else
        log "$ERROR Failed to set GTK icon theme to: '$ICON_THEME'"
    fi
    
    if gsettings set org.gnome.desktop.interface gtk-theme "$THEME"; then
        log "$SUCCESS Set GTK theme to: '$THEME'"
        return 0
    else
        log "$ERROR Failed to set GTK theme to: '$THEME'"
        return 1
    fi
}

## Set the theme used by spicetify
set_spicetify_theme() {
    local THEME="$1"
    local SCHEME="$2"

    if spicetify config current_theme "$THEME" > /dev/null; then
        log "$SUCCESS Set Spicetify theme to: '$THEME'"
    else
        log "$ERROR Failed to set Spicetify theme to: '$THEME'"
    fi

    if spicetify config color_scheme "$SCHEME" > /dev/null; then
        log "$SUCCESS Set Spicetify color scheme to: '$SCHEME'"
    else
        log "$ERROR Failed to set Spicetify color scheme to: '$SCHEME'"
    fi

    if spicetify apply > /dev/null; then
        log "$SUCCESS Applied Spicetify theme: '$THEME'"
        log "$SUCCESS Applied Spicetify color scheme: '$SCHEME'"
        return 0
    else
        log "$ERROR Failed to apply Spicetify theme: '$THEME'"
        log "$ERROR Failed to apply Spicetify color scheme: '$SCHEME'"
        return 1
    fi
}

## Start an app
start_app() {
    local APP="$1"

    if pgrep -x "$APP" > /dev/null; then
        log "$OK App is already running: '$APP'"
        return 0
    else
        log "$ALERT App is not running (starting...): '$APP'"
        
        if hyprctl dispatch exec "$APP" > /dev/null; then
            sleep 1
            log "$SUCESS Started app: '$APP'"
            return 0
        else
            log "$ERROR Failed to start app: '$APP', check errors above"
            return 1
        fi
    fi
}


# Execution #

clear

## Select theme and set its variables
section "Select theme"

ask_user 3 \
    "Catppuccin Mocha Lavender" "THEME=catppuccin-mocha-lavender" \
    "Gruvbox Dark" "THEME=gruvbox-dark" \
    "Minimalistic" "THEME=minimalistic"

if [[ "$THEME" == "catppuccin-mocha-lavender" ]]; then
    GTK_THEME="catppuccin-mocha-lavender-standard+default"
    GTK_ICON_THEME="Adwaita"

    SPICETIFY_THEME="catppuccin"
    SPICETIFY_SCHEME="mocha"

    VSCODE_THEME="Catppuccin Mocha"

    WALLPAPER="catppuccin-mocha-lavender.png"
elif [[ "$THEME" == "gruvbox-dark" ]]; then
    GTK_THEME="Gruvbox-Yellow-Dark"
    GTK_ICON_THEME="Adwaita"

    SPICETIFY_THEME="gruvify"
    SPICETIFY_SCHEME=" "

    VSCODE_THEME="Gruvbox Dark Hard"

    WALLPAPER="gruvbox-dark.png"
elif [[ "$THEME" == "minimalistic" ]]; then
    GTK_THEME="Adwaita-dark"
    GTK_ICON_THEME="Adwaita"

    SPICETIFY_THEME=" "
    SPICETIFY_SCHEME=" "

    VSCODE_THEME="GitHub Dark"

    WALLPAPER="minimalistic.png"
fi

## Copy generic files to directories
section "Copy generic files"
copy "$HOME/dotfiles/themes/generic/." "$HOME"
echo

## Copy .config to home
section "Copy .config Folder"
copy "$HOME/dotfiles/themes/$THEME/.config" "$HOME"
echo

## Set GTK theme and cursor
section "Set GTK theme"
set_gtk_theme "$GTK_ICON_THEME" "$GTK_THEME"
echo

## Set VSCode theme
section "Set VSCode theme"
edit_option_in_json "$HOME/.config/Code/User/settings.json" "workbench.colorTheme" "$VSCODE_THEME"
echo

## Set Spicetify theme
section "Set Spicetify theme"
set_spicetify_theme "$SPICETIFY_THEME" "$SPICETIFY_SCHEME"
echo

## Set wallpaper
section "Apply wallpaper"
start_app "hyprpaper"
apply_wallpaper "$HOME/dotfiles/themes/wallpapers/$WALLPAPER"
echo

## Restart apps
section "Restart apps"
restart_app "swaync"
restart_app "waybar"
echo
