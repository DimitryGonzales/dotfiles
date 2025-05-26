#!/usr/bin/env bash

# Functions 
copy() {
    local FILE="$1"
    local DIRECTORY="$2"

    if cp "$FILE" "$DIRECTORY"; then
        printf "✅ Copied: '%s' to '%s'\n" "$FILE" "$DIRECTORY"
    else
        printf "❌ Failed to copy: '%s' to '%s', check errors above\n" "$FILE" "$DIRECTORY"
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

start_app_if_not_running() {
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

restart_or_start_app() {
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

clear

# Ask if user wants to set ZSH as default shell
if [ "$SHELL" != "$(command -v zsh)" ]; then
    while true; do
        printf "Current shell: '%s'\n" "$SHELL"
        printf "Do you want to set ZSH as your default shell? (Y/n)\n\n"

        read -r choice
        choice=${choice:-y}
        choice=${choice,,}

        clear
        case "$choice" in
            y|yes)
                sudo chsh -s "$(command -v zsh)" "$USER"
                clear
                printf "✅ ZSH default shell setup executed successfully(reboot computer to apply changes)\n\n"
                break
                ;;
            n|no)
                printf "❌ Skipping ZSH default shell setup.\n\n"
                break
                ;;
            *)
                printf "⚠️ Invalid input. Please enter (y)es or (n)o.\n\n"
                ;;
        esac
    done
fi

# Ask user what theme to apply
while true; do
    printf "Choose a theme:\n\n"
    printf "1 - Catppuccin Mocha\n\n"

    read -n 1 -r choice
    [ -z "$choice" ] && clear && continue

    case "$choice" in
        1|one)
            # Theme name
            THEME="catppuccin-mocha-lavender"

            # VSCode theme name
            VSCODE_THEME="Catppuccin Mocha"
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
SOURCES_ROFI_DIR="$SOURCES_DIR/rofi"
SOURCES_SWAYNC_DIR="$SOURCES_DIR/swaync"
SOURCES_VESKTOP_DIR="$SOURCES_DIR/vesktop"
SOURCES_WALLPAPER_DIR="$SOURCES_DIR/wallpaper"
SOURCES_WAYBAR_DIR="$SOURCES_DIR/waybar"
SOURCES_ZSH_DIR="$SOURCES_DIR/zsh"

# Files directories
BASHRC="$SOURCES_BASH_DIR/$THEME/.bashrc"
FOOT_CONFIG="$SOURCES_FOOT_DIR/$THEME/foot.ini"
GTK_SETTINGS="$SOURCES_GTK_DIR/$THEME/settings.ini"
HYPRLAND_STYLE="$SOURCES_HYPRLAND_DIR/$THEME/style.conf"
HYPRLOCK_CONFIG="$SOURCES_HYPRLAND_DIR/$THEME/hyprlock.conf"
HYPRPAPER_CONFIG="$SOURCES_HYPRLAND_DIR/$THEME/hyprpaper.conf"
KITTY_CONFIG="$SOURCES_KITTY_DIR/$THEME/kitty.conf"
KITTY_PALETTE="$SOURCES_KITTY_DIR/$THEME/$THEME.conf"
NEOFETCH_CONFIG="$SOURCES_NEOFETCH_DIR/$THEME/config.conf"
ROFI_CONFIG="$SOURCES_ROFI_DIR/$THEME/config.rasi"
ROFI_PALETTE="$SOURCES_ROFI_DIR/$THEME/$THEME.rasi"
SWAYNC_STYLE="$SOURCES_SWAYNC_DIR/$THEME/style.css"
VESKTOP_THEME="$SOURCES_VESKTOP_DIR/$THEME/themes/$THEME.css"
VESKTOP_SETTINGS="$SOURCES_VESKTOP_DIR/$THEME/settings/settings.json"
VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
WALLPAPER="$SOURCES_WALLPAPER_DIR/$THEME.png"
WAYBAR_CONFIG="$SOURCES_WAYBAR_DIR/$THEME/config.jsonc"
WAYBAR_PALETTE="$SOURCES_WAYBAR_DIR/$THEME/palette.css"
WAYBAR_STYLE="$SOURCES_WAYBAR_DIR/$THEME/style.css"
ZSHRC="$SOURCES_ZSH_DIR/$THEME/.zshrc"

# Apps directories
FOOT_DIR="$HOME/.config/foot"
GTK_DIR="$HOME/.config/gtk-3.0"
HYPR_DIR="$HOME/.config/hypr"
KITTY_DIR="$HOME/.config/kitty"
NEOFETCH_DIR="$HOME/.config/neofetch"
ROFI_DIR="$HOME/.config/rofi"
SWAYNC_DIR="$HOME/.config/swaync"
VESKTOP_DIR="$HOME/.config/vesktop"
WAYBAR_DIR="$HOME/.config/waybar"

clear

# Execution

# Print theme name
printf "🎨 Theme: %s\n\n" "$THEME"

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

# Rofi
printf "• Rofi\n"

check_directory "$ROFI_DIR"
copy "$ROFI_CONFIG" "$ROFI_DIR"
copy "$ROFI_PALETTE" "$ROFI_DIR"
echo

# SwayNC
printf "• SwayNC\n"

check_directory "$SWAYNC_DIR"
copy "$SWAYNC_STYLE" "$SWAYNC_DIR"
echo

# Vesktop
printf "• Vesktop\n"

check_directory "$VESKTOP_DIR/settings"
check_directory "$VESKTOP_DIR/themes"
copy "$VESKTOP_SETTINGS" "$VESKTOP_DIR/settings"
copy "$VESKTOP_THEME" "$VESKTOP_DIR/themes"
echo

#VSCode
printf "• VSCode\n"

if [ -f "$VSCODE_SETTINGS" ]; then
    printf "📄 File already exists: %s\n" "$VSCODE_SETTINGS"
else
    if echo {} > "$VSCODE_SETTINGS"; then
        printf "🛠️ Created file: '%s'\n" "$VSCODE_SETTINGS"
    else
        printf "❌ Failed to create file: '%s', check errors above\n" "$VSCODE_SETTINGS"
    fi
fi

if grep -q '"workbench.colorTheme"' "$VSCODE_SETTINGS"; then
    printf "✅ Updated color theme (install if you don't have it): '%s'\n" "$VSCODE_THEME"
    sed -i 's/\("workbench.colorTheme"[[:space:]]*:[[:space:]]*"\)[^"]*\("\)/\1'"$VSCODE_THEME"'\2/' "$VSCODE_SETTINGS"
else
    printf "✅ Inserted color theme (install if you don't have it): '%s'\n" "$VSCODE_THEME"
    sed -i '$i\  "workbench.colorTheme": "'"$VSCODE_THEME"'",' "$VSCODE_SETTINGS"
fi
echo

# Wallpaper
printf "• Wallpaper\n"

start_app_if_not_running "hyprpaper"

if hyprctl hyprpaper reload ,"$WALLPAPER" > /dev/null; then
    printf "✅ Applied: '%s'\n" "$WALLPAPER"
fi
echo

# Waybar
printf "• Waybar\n"

check_directory "$WAYBAR_DIR"
copy "$WAYBAR_CONFIG" "$WAYBAR_DIR"
copy "$WAYBAR_PALETTE" "$WAYBAR_DIR"
copy "$WAYBAR_STYLE" "$WAYBAR_DIR"
restart_or_start_app "waybar"
echo

# ZSH
printf "• ZSH\n"

copy "$ZSHRC" "$HOME"
echo