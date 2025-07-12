#!/usr/bin/env bash

clear

# Functions 
apply_wallpaper() {
    local WALLPAPER="$1"

    if hyprctl hyprpaper wallpaper ,"$WALLPAPER" > /dev/null; then
        printf "✅ Applied wallpaper: '%s'\n" "$WALLPAPER"
    else
        printf "❌ Failed to apply wallpaper(must be a png): '%s', check errors above\n" "$WALLPAPER"
    fi
}

change_directory() {
    local DIRECTORY="$1"

    if cd "$DIRECTORY"; then
        log "✅ Changed directory to: '$DIRECTORY'" 
        return 0
    else
        log "❌ Failed to change directory to: '$DIRECTORY'"
        return 1
    fi
}

check_directory() {
    local DIRECTORY="$1"

    if [ -d "$DIRECTORY" ]; then
        printf "📁 Directory already exists: '%s'\n" "$DIRECTORY"
    else
        printf "⚠️ Directory doesn't exists (creating...): '%s'\n" "$DIRECTORY"

        if mkdir -p "$DIRECTORY"; then
            printf "🛠️ Created directory: '%s'\n" "$DIRECTORY"
        else
            printf "❌ Failed to create directory: '%s', check errors above\n" "$DIRECTORY"
        fi
    fi
}

copy() {
    local FILE="$1"
    local DIRECTORY="$2"

    if cp -r "$FILE" "$DIRECTORY"; then
        printf "✅ Copied: '%s' to '%s'\n" "$FILE" "$DIRECTORY"
    else
        printf "❌ Failed to copy: '%s' to '%s', check errors above\n" "$FILE" "$DIRECTORY"
    fi
}

create_empty_json() {
    local FILE="$1"

    if [ -f "$FILE" ]; then
        printf "📄 JSON file already exists: %s\n" "$FILE"
    else
        if echo {} > "$FILE"; then
            printf "🛠️ Created empty JSON file: '%s'\n" "$FILE"
        else
            printf "❌ Failed to create empty JSON file: '%s', check errors above\n" "$FILE"
        fi
    fi
}

edit_option_in_json() {
    local FILE="$1"
    local OPTION="$2"
    local VALUE="$3"

    if grep -q "\"$OPTION\"" "$FILE"; then
        local CURRENT_VALUE
        CURRENT_VALUE=$(grep "\"$OPTION\"" "$FILE" | sed -E 's/.*"'$OPTION'":[[:space:]]*"(.*)".*/\1/')

        if [[ "$CURRENT_VALUE" == "$VALUE" ]]; then
            printf "ℹ️ '%s' is already set to: '%s'\n" "$OPTION" "$VALUE"
        else
            if sed -i 's/\("'"$OPTION"'"[[:space:]]*:[[:space:]]*"\)[^"]*\("\)/\1'"$VALUE"'\2/' "$FILE"; then
                printf "✅ Updated '%s' to: '%s'\n" "$OPTION" "$VALUE"
            else
                printf "❌ Failed to update '%s' to: '%s'\n" "$OPTION" "$VALUE"
            fi
        fi
    else
        if sed -i '$i\  "'"$OPTION"'": "'"$VALUE"'",' "$FILE"; then
            printf "✅ Inserted: '%s: %s'\n" "$OPTION" "$VALUE"
        else
            printf "❌ Failed to insert '%s: %s'\n" "$OPTION" "$VALUE"
        fi
    fi
}

restart_app() {
    local APP="$1"

    if pgrep -x "$APP" > /dev/null; then
        printf "🚦 App is already running (needs restart): '%s'\n" "$APP"

        if pkill "$APP" && hyprctl dispatch exec "$APP" > /dev/null; then
            printf "🔄 Restarted app: '%s'\n" "$APP"
        else
            printf "❌ Failed to restart app: '%s', check errors above\n" "$APP"
        fi
    else
        printf "⚠️ App is not running (starting...): '%s'\n" "$APP"

        if hyprctl dispatch exec "$APP" > /dev/null; then
            sleep 1
            printf "🚀 Started app: '%s'\n" "$APP"
        else
            printf "❌ Failed to start app: '%s', check errors above\n" "$APP"
        fi
    fi
}

set_gtk_theme() {
    local THEME="$1"

    if gsettings set org.gnome.desktop.interface icon-theme "$GTK_ICON_THEME"; then
        printf "✅ Set GTK icon theme to: %s\n" "$GTK_ICON_THEME"
    else
        printf "❌ Failed to set GTK icon theme to: %s\n" "$GTK_ICON_THEME"
    fi
    
    if gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"; then
        printf "✅ Set GTK theme to: %s\n" "$GTK_THEME"
    else
        printf "❌ Failed to set GTK theme to: %s\n" "$GTK_THEME"
    fi
}

set_spicetify_theme() {
    local SPICETIFY_THEME="$1"

    if spicetify config current_theme "$SPICETIFY_THEME" > /dev/null; then
        printf "✅ Set Spicetify theme to: %s\n" "$SPICETIFY_THEME"
    else
        printf "❌ Failed to set Spicetify theme to: %s\n" "$SPICETIFY_THEME"
    fi

    if spicetify apply > /dev/null; then
        printf "✅ Applied Spicetify theme: %s\n" "$SPICETIFY_THEME"
    else
        printf "❌ Failed to apply Spicetify theme: %s\n" "$SPICETIFY_THEME"
    fi
}

start_app() {
    local APP="$1"

    if pgrep -x "$APP" > /dev/null; then
        printf "🚦 App is already running: '%s'\n" "$APP"
    else
        printf "⚠️ App is not running (starting...): '%s'\n" "$APP"
        
        if hyprctl dispatch exec "$APP" > /dev/null; then
            sleep 1
            printf "🚀 Started app: '%s'\n" "$APP"
        else
            printf "❌ Failed to start app: '%s', check errors above\n" "$APP"
        fi
    fi
}

# Ask user what theme to apply
while true; do
    printf "Choose a theme:\n\n"
    printf "1 - Catppuccin Mocha\n"
    printf "2 - Gruvbox Dark\n"
    printf "3 - Minimalistic\n"
    echo

    read -n 1 -r choice
    [ -z "$choice" ] && clear && continue

    case "$choice" in
        1|one)
            # GTK icon theme
            GTK_ICON_THEME="Adwaita"

            # GTK theme
            GTK_THEME="catppuccin-mocha-lavender-standard+default"

            #Spicetify theme
            SPICETIFY_THEME="marketplace"

            # Theme name
            THEME="catppuccin-mocha-lavender"

            # VSCode theme name
            VSCODE_THEME="Catppuccin Mocha"
            break
            ;;
        2|two)
            # GTK icon theme
            GTK_ICON_THEME="Adwaita"

            # GTK theme name
            GTK_THEME="Gruvbox-Yellow-Dark"

            #Spicetify theme
            SPICETIFY_THEME="marketplace"

            # Theme name
            THEME="gruvbox-dark"

            # VSCode theme name
            VSCODE_THEME="Gruvbox Dark Hard"
            break
            ;;
        3|three)
            # GTK icon theme
            GTK_ICON_THEME="Adwaita"

            # GTK theme name
            GTK_THEME="Adwaita"

            #Spicetify theme
            SPICETIFY_THEME=" "

            # Theme name
            THEME="minimalistic"

            # VSCode theme name
            VSCODE_THEME="GitHub Dark"
            break
            ;;
        *)
            clear
            printf "❌ Invalid choice, try again:\n\n"
            ;;
    esac
done

# Sources
SOURCES_DIR="$HOME/sources"
SOURCES_BASH_DIR="$SOURCES_DIR/bash"
SOURCES_FOOT_DIR="$SOURCES_DIR/foot"
SOURCES_GTK_DIR="$SOURCES_DIR/gtk"
SOURCES_HYPRLAND_DIR="$SOURCES_DIR/hyprland"
SOURCES_KITTY_DIR="$SOURCES_DIR/kitty"
SOURCES_NEOFETCH_DIR="$SOURCES_DIR/neofetch"
SOURCES_QT_DIR="$SOURCES_DIR/qt"
SOURCES_ROFI_DIR="$SOURCES_DIR/rofi"
SOURCES_SWAYNC_DIR="$SOURCES_DIR/swaync"
SOURCES_VENCORD_DIR="$SOURCES_DIR/vencord"
SOURCES_WALLPAPER_DIR="$SOURCES_DIR/wallpaper"
SOURCES_WAYBAR_DIR="$SOURCES_DIR/waybar"

# Files directories
BASHRC="$SOURCES_BASH_DIR/$THEME/.bashrc"
FOOT_CONFIG="$SOURCES_FOOT_DIR/$THEME/foot.ini"
GTK_SETTINGS="$SOURCES_GTK_DIR/$THEME/settings.ini"
HYPRLAND_STYLE="$SOURCES_HYPRLAND_DIR/$THEME/style.conf"
HYPRLOCK_CONFIG="$SOURCES_HYPRLAND_DIR/$THEME/hyprlock.conf"
HYPRPAPER_CONFIG="$SOURCES_HYPRLAND_DIR/$THEME/hyprpaper.conf"
KITTY_CONFIG="$SOURCES_KITTY_DIR/$THEME/kitty.conf"
KITTY_PALETTE="$SOURCES_KITTY_DIR/$THEME/palette.conf"
NEOFETCH_CONFIG="$SOURCES_NEOFETCH_DIR/$THEME/config.conf"
QT5_CONFIG="$SOURCES_QT_DIR/$THEME/qt5ct.conf"
QT6_CONFIG="$SOURCES_QT_DIR/$THEME/qt6ct.conf"
ROFI_CONFIG="$SOURCES_ROFI_DIR/$THEME/config.rasi"
ROFI_THEME="$SOURCES_ROFI_DIR/$THEME/theme.rasi"
SWAYNC_STYLE="$SOURCES_SWAYNC_DIR/$THEME/style.css"
VENCORD_THEME="$SOURCES_VENCORD_DIR/$THEME/themes/theme.css"
VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
WALLPAPER="$SOURCES_WALLPAPER_DIR/$THEME.png"
WAYBAR_CONFIG="$SOURCES_WAYBAR_DIR/$THEME/config.jsonc"
WAYBAR_PALETTE="$SOURCES_WAYBAR_DIR/$THEME/palette.css"
WAYBAR_STYLE="$SOURCES_WAYBAR_DIR/$THEME/style.css"

# Apps directories
FOOT_DIR="$HOME/.config/foot"
GTK_DIR="$HOME/.config/gtk-3.0"
HYPR_DIR="$HOME/.config/hypr"
KITTY_DIR="$HOME/.config/kitty"
NEOFETCH_DIR="$HOME/.config/neofetch"
QT5_DIR="$HOME/.config/qt5ct"
QT6_DIR="$HOME/.config/qt6ct"
ROFI_DIR="$HOME/.config/rofi"
SWAYNC_DIR="$HOME/.config/swaync"
VENCORD_DIR="$HOME/.config/Vencord"
WAYBAR_DIR="$HOME/.config/waybar"

clear

# Execution

# Print theme name
printf "🎨 Theme: %s\n\n" "$THEME"

# Change directory to home
change_directory "$HOME"
echo

# BASH
printf "• BASH\n"

copy "$BASHRC" "$HOME"
echo

# Foot
printf "• Foot\n"

check_directory "$FOOT_DIR"
copy "$FOOT_CONFIG" "$FOOT_DIR"
echo

# GTK
printf "• GTK\n"

check_directory "$GTK_DIR"
copy "$GTK_SETTINGS" "$GTK_DIR"
set_gtk_theme "$GTK_THEME"
echo

# hyprland and hyprapps
printf "• hyprland and hyprapps\n"

check_directory "$HYPR_DIR/source"
copy "$HYPRLAND_STYLE" "$HYPR_DIR/source"
copy "$HYPRLOCK_CONFIG" "$HYPR_DIR"
copy "$HYPRPAPER_CONFIG" "$HYPR_DIR"
echo

# Kitty
printf "• Kitty\n"

check_directory "$KITTY_DIR"
copy "$KITTY_CONFIG" "$KITTY_DIR"
copy "$KITTY_PALETTE" "$KITTY_DIR"
echo

# Neofetch
printf "• Neofetch\n"

check_directory "$NEOFETCH_DIR"
copy "$NEOFETCH_CONFIG" "$NEOFETCH_DIR"
echo

# QT
printf "• QT\n"

check_directory "$QT5_DIR"
copy "$QT5_CONFIG" "$QT5_DIR"
check_directory "$QT6_DIR"
copy "$QT6_CONFIG" "$QT6_DIR"
echo

# Rofi
printf "• Rofi\n"

check_directory "$ROFI_DIR"
copy "$ROFI_CONFIG" "$ROFI_DIR"
copy "$ROFI_THEME" "$ROFI_DIR"
echo

# Spicetify
printf "• Spicetify\n"
set_spicetify_theme "$SPICETIFY_THEME"
echo

# SwayNC
printf "• SwayNC\n"

check_directory "$SWAYNC_DIR"
copy "$SWAYNC_STYLE" "$SWAYNC_DIR"
restart_app "swaync"
echo

# Vencord
printf "• Vencord\n"
check_directory "$VENCORD_DIR/themes"
copy "$VENCORD_THEME" "$VENCORD_DIR/themes"
echo

#VSCode
printf "• VSCode\n"

create_empty_json "$VSCODE_SETTINGS"
edit_option_in_json "$VSCODE_SETTINGS" "workbench.colorTheme" "$VSCODE_THEME"
echo

# Wallpaper
printf "• Wallpaper\n"

start_app "hyprpaper"
apply_wallpaper "$WALLPAPER"
echo

# Waybar
printf "• Waybar\n"

check_directory "$WAYBAR_DIR"
copy "$WAYBAR_CONFIG" "$WAYBAR_DIR"
copy "$WAYBAR_PALETTE" "$WAYBAR_DIR"
copy "$WAYBAR_STYLE" "$WAYBAR_DIR"
restart_app "waybar"
echo
