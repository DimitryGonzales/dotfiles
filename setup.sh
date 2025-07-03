#!/usr/bin/env bash

set -e
trap 'log "[FAIL] Script execution failed. Exiting..."' ERR

#############
# Variables #
#############

BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"
RESET="\033[0m"

#############
# Functions #
#############

log() {
    printf "[${MAGENTA}Script${RESET}] %b\n" "$*"
}

add_user_to_group() {
    local USERNAME="${SUDO_USER:-$USER}"

    for GROUP in "$@"; do
        if id -nG "$USERNAME" | grep -qw "$GROUP"; then
            log "[${BLUE}OK${RESET}] '$USERNAME' is already in group: '$GROUP'."
        else
            if sudo gpasswd -a "$USERNAME" "$GROUP"; then
                log "[${GREEN}SUCCESS${RESET}] Added '$USERNAME' to group: '$GROUP'."
            else
                log "[${RED}ERROR${RESET}] Failed to add '$USERNAME' to group: '$GROUP'"
                return 1
            fi
        fi
    done

    return 0
}

authenticate() {
    if sudo -v; then
        log "[${GREEN}SUCCESS${RESET}] Successfully authenticated."
        return 0
    else
        log "[${RED}ERROR${RESET}] Failed to authenticate."
        return 1
    fi
}

change_directory() {
    local DIRECTORY="$1"

    if cd "$DIRECTORY" > /dev/null; then
        log "[${GREEN}SUCCESS${RESET}] Changed directory to: '$DIRECTORY'" 
        return 0
    else
        log "[${RED}ERROR${RESET}] Couldn't change directory to: '$DIRECTORY'"
        return 1
    fi
}

check_package() {
    local RESULT=0

    for PACKAGE in "$@"; do
        if sudo pacman -Q "$PACKAGE" &> /dev/null; then
            log "[${BLUE}OK${RESET}] Package is up to date: '$PACKAGE'"
        else
            log "[${YELLOW}ALERT${RESET}] Package is not installed/up to date: '$PACKAGE'"
            RESULT=1
        fi
    done
    
    return $RESULT
}

copy() {
    local SOURCE="$1"
    local DESTINATION="$2"

    if sudo cp -r "$SOURCE" "$DESTINATION"; then
        log "[${GREEN}SUCCESS${RESET}] Copied: '$SOURCE' to '$DESTINATION'"
        return 0
    else
        log "[${RED}ERROR${RESET}] Failed to copy: '$SOURCE' to '$DESTINATION'"
        return 1
    fi
}

edit_greetd_command() {
    local COMMAND="$1"

    copy "/etc/greetd/config.toml" "/etc/greetd/config.toml.bak"

    if sudo sed -i "s|^.*command *=.*|command = \"$COMMAND\"|" /etc/greetd/config.toml; then
        log "[${GREEN}SUCCESS${RESET}] Edited greetd command to: '$COMMAND'"
        return 0
    else
        log "[${RED}ERROR${RESET}] Failed to edit greetd command to: '$COMMAND'"
        return 1   
    fi
}

git_clone() {
    local URL="$1"

    if git clone "$URL" > /dev/null; then
        log "[${GREEN}SUCCESS${RESET}] Git cloned repository: '$URL'"
        return 0
    else
        log "[${RED}ERROR${RESET}] Failed to git clone repository: '$URL'"
        return 1
    fi
}

make_directory() {
    local DIRECTORY="$1"

    if [ ! -d "$DIRECTORY" ]; then
        if sudo mkdir -p "$DIRECTORY"; then
            log "[${GREEN}SUCCESS${RESET}] Created directory: '$DIRECTORY'"
            return 0
        else
            log "[${RED}ERROR${RESET}] Failed to create directory: '$DIRECTORY'"
            return 1
        fi
    else
        log "[${BLUE}OK${RESET}] Directory already exists: '$DIRECTORY'"
        return 0
    fi
}

make_package() {
    if makepkg -si > /dev/null; then
        log "[${GREEN}SUCCESS${RESET}] Successfully make package."
        return 0
    else
        log "[${RED}ERROR${RESET}] Failed to make package."
        return 1
    fi
}

pacman_install() {
    if ! check_package "$@"; then
        log "Installing missing packages..."

        if sudo pacman -S --needed "$@"; then
            log "[${GREEN}SUCCESS${RESET}] Successfully installed all packages."
            return 0
        else
            log "[${RED}ERROR${RESET}] Failed to install all packages."
            return 1
        fi
    else
        log "[${BLUE}OK${RESET}] All packages are already installed."
        return 0
    fi
}

paru_install() {
    if ! check_package "$@"; then
        log "Installing missing packages..."

        if paru -S --needed "$@"; then
            log "[${GREEN}SUCCESS${RESET}] Successfully installed all packages."
            return 0
        else
            log "[${RED}ERROR${RESET}] Failed to install all packages."
            return 1
        fi
    else
        log "[${BLUE}OK${RESET}] All packages are already installed."
        return 0
    fi
}

system_enable() {
    local SERVICE="$1"

    if systemctl is-enabled --quiet "$SERVICE"; then
        log "[${BLUE}OK${RESET}] Service is already enabled: '$SERVICE'"
        return 0
    else
        if systemctl enable "$SERVICE"; then
            log "[${GREEN}SUCCESS${RESET}] Successfully enabled service: '$SERVICE'"
            return 0
        else
            log "[${RED}ERROR${RESET}] Failed to enable service: '$SERVICE'"
            return 1
        fi
    fi
}

system_start() {
    local SERVICE="$1"

    if systemctl is-active --quiet "$SERVICE"; then
        log "[${BLUE}OK${RESET}] Service is already started: '$SERVICE'"
        return 0
    else
        if systemctl start "$SERVICE"; then
            log "[${GREEN}SUCCESS${RESET}] Successfully started service: '$SERVICE'"
            return 0
        else
            log "[${RED}ERROR${RESET}] Failed to start service: '$SERVICE'"
            return 1
        fi
    fi
}

############
# Packages #
############

pacman_packages=(
    # Pacman {

    # Utilities
    pacman-contrib

    # }

    # Drivers {

    # AMDGPU 
    mesa
    lib32-mesa
    xf86-video-amdgpu
    vulkan-radeon
    lib32-vulkan-radeon

    # Pipewire
    pipewire
    lib32-pipewire
    pipewire-audio
    pipewire-alsa
    pipewire-pulse
    pipewire-jack
    lib32-pipewire-jack
    wireplumber

    # }

    # Fonts {

    # Noto Fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra

    # Font Awesome
    ttf-font-awesome
    otf-font-awesome

    # Liberation
    ttf-liberation

    # JetBrains Mono
    ttf-jetbrains-mono
    ttf-jetbrains-mono-nerd

    # }

    # GTK {

    # Base
    gtk2
    gtk3
    gtk4

    #Themes
    gnome-themes-extra

    # }

    # QT {

    # Base
    qt5ct
    qt5-wayland
    qt6ct
    qt6-wayland

    # }

    # Window Manager {

    # Greeter
    greetd
    greetd-tuigreet
    
    # Hyprland
    hyprland

    # Hypr apps
    hyprpaper
    hyprpicker
    hyprlock
    hyprshot
    hyprpolkitagent

    # Hypr Utilities
    hyprcursor
    hyprutils
    hyprgraphics
    hyprland-qtutils

    # XDG Desktop Portal
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk

    # }

    # Apps/Tools {

    # System
    btrfs-progs
    catfish
    chafa
    cliphist
    file-roller
    gamemode
    lib32-gamemode
    gvfs
    gvfs-mtp
    inetutils
    ntfs-3g
    reflector
    thunar-archive-plugin
    thunar-media-tags-plugin
    thunar-volman
    tumbler
    ufw

    # CLI
    fastfetch
    ncdu
    neovim
    speedtest-cli
    vim

    # General
    discord
    firefox
    foot
    goverlay
    gparted
    gsmartcontrol
    helvum
    kitty
    libreoffice-fresh
    lutris
    mangohud
    mission-center
    nwg-look
    obs-studio
    pavucontrol
    qbittorrent
    rofi
    rofi-emoji
    speedcrunch
    spotify-launcher
    steam
    swaync
    thunar
    vlc
    w3m
    waybar
    zed

    # }
)

aur_packages=(
    # GTK {

    # Themes
    catppuccin-gtk-theme-mocha
    gruvbox-gtk-theme-git

    # }

    # Apps/Tools {

    # System
    openrazer-daemon

    # CLI
    gallery-dl
    oh-my-bash-git
    rofi-power-menu
    spicetify-cli
    spicetify-marketplace-bin
    vencord-hook

    # General
    heroic-games-launcher-bin
    jdownloader2
    opentabletdriver
    polychromatic
    protonup-qt
    qimgv
    rofi-power-menu
    visual-studio-code-bin
    woeusb-ng
    zen-browser-bin

    # }
)

#############
# Execution #
#############

# Authentication
log "[Authentication]\n"
if authenticate; then
    clear
else
    echo
    exit 1
fi

change_directory "$HOME"
echo

# Paru
log "[${CYAN}Paru${RESET}]"

if ! check_package "paru"; then
    pacman_install "base-devel"
    git_clone "https://aur.archlinux.org/paru.git"
    change_directory "paru"
    make_package
    change_directory "$HOME"
fi

echo

# Install packages
# Pacman
log "[${CYAN}Pacman Packages${RESET}]"
pacman_install "${pacman_packages[@]}"
echo

# AUR
log "[${CYAN}AUR Packages${RESET}]"
paru_install "${aur_packages[@]}"
echo

# Discord (triggers Vencord Hook)
log "[${CYAN}Discord${RESET}]"
sudo pacman -S --noconfirm discord
echo

# Services
# Paccache
log "[${CYAN}Paccache${RESET}]"
system_enable "paccache.timer"
system_start "paccache.timer"
echo

# UFW
log "[${CYAN}UFW${RESET}]"
system_enable "ufw"
system_start "ufw"
echo

# Greetd
log "[${CYAN}Greetd${RESET}]"
edit_greetd_command "tuigreet --cmd hyprland"
system_enable "greetd"
echo

# Groups
log "[${CYAN}Groups${RESET}]"
add_user_to_group "input" "gamemode"
echo

# End
log "[${GREEN}SUCCESS${RESET}] Script executed with success."
echo

# Reboot
while true; do
    read -rp "[REBOOT] Do you want to reboot? [Y/n]: " RESPONSE
    RESPONSE=${RESPONSE,,}

    case "$RESPONSE" in
        n|no)
            log "It is recommended to reboot! Exiting..."
            exit 0
            ;;
        y|yes|"")
            log "Rebooting..."
            sleep 3
            reboot
            ;;
        *)
            log "Invalid choice, try again:"
            ;;
    esac
done
