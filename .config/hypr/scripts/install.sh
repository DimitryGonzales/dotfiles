#!/usr/bin/env bash

# Elevate privilages
sudo -v

BLACK="\e[0;30m"
RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
BLUE="\e[0;34m"
MAGENTA="\e[0;35m"
CYAN="\e[0;36m"
WHITE="\e[0;37m"
RESET="\e[0m"

abort() {
    printf "%bExecution aborted!%b\n" "$RED" "$RESET" >&2
    exit 1
}

# Check and install paru
if ! pacman -Q paru > /dev/null 2>&1; then
    printf "%bparu isn't installed, installing...%b\n" "$YELLOW" "$RESET"

    if ! (
        sudo pacman -S --needed base-devel git &&
        cd /tmp &&
        git clone https://aur.archlinux.org/paru.git &&
        cd paru &&
        makepkg -si &&
        cd ~
    ); then
        printf "%bFailed to install paru!%b\n" "$RED" "$RESET" >&2
        exit 1
    fi
    printf "%bparu installed successfully.%b\n" "$GREEN" "$RESET"
fi

# Check and install packages
packages=(
    # App
    brave-bin
    ente-auth-bin
    heroic-games-launcher-bin
    localsend-bin
    pear-desktop-bin
    protonplus
    qimgv
    schildichat-desktop-bin
    ventoy-bin

    # Software
    gallery-dl-bin
    icoextract
    millennium
    oh-my-zsh-git
    pfetch
    vencord-hook
    zsh-pure-prompt

    # Driver: mesa/vulkan
    lib32-mesa
    lib32-vulkan-radeon
    mesa
    vulkan-radeon

    # Driver: mouse(Razer)
    openrazer-daemon
    polychromatic

    # Driver: tablet
    opentabletdriver

    # Hyprland
    hyprland
    hyprlock
    hyprpicker
    hyprpolkitagent
    hyprshot

    # Linux
    linux-headers

    # Pipewire
    helvum
    lib32-pipewire
    lib32-pipewire-jack
    pipewire
    pipewire-alsa
    pipewire-audio
    pipewire-jack
    pipewire-pulse
    wireplumber

    # Style: cursor
    bibata-cursor-theme-bin

    # Style: font
    inter-font
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    otf-font-awesome

    # Style: GTK
    adw-gtk-theme
    adwaita-icon-theme
    gtk3
    gtk4

    # Style: Qt
    darkly-bin
    qt5-wayland
    qt5ct
    qt6-wayland
    qt6ct

    # XDG
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
)

printf "Packages:\n"
packages_needed=false
for item in "${packages[@]}"; do
    if pacman -Q "$item" > /dev/null 2>&1; then
        printf "%b%s%b\n" "$GREEN" "$item" "$RESET"
    else
        printf "%b%s%b\n" "$YELLOW" "$item" "$RESET"
        packages_needed=true
    fi
done

if [[ "$packages_needed" = true ]]; then
    printf "Install missing packages? [Y/n] " && read -r packages_confirm
    packages_confirm="${packages_confirm,,}"
    [[ "$packages_confirm" == "n" ]] && abort

    if ! paru -S --needed "${packages[@]}"; then
        printf "%bFailed to install all missing packages!%b\n" "$RED" "$RESET" >&2
        exit 1
    fi
    printf "%bInstalled all missing packages successfully.%b\n\n" "$GREEN" "$RESET"
fi

# Add user to groups
groups=(
    gamemode
    openrazer
    plugdev
)

printf "Groups:\n"
groups_needed=false
for item in "${groups[@]}"; do
    if groups "$USER" | grep -q "$item"; then
        printf "%b%s%b\n" "$GREEN" "$item" "$RESET"
    else
        printf "%b%s%b\n" "$YELLOW" "$item" "$RESET"
        groups_needed=true
    fi
done

if [[ "$groups_needed" == true ]]; then
    printf "Add %s to missing groups? [Y/n] " "$USER" && read -r groups_confirm
    groups_confirm="${groups_confirm,,}"
    [[ "$groups_confirm" == "n" ]] && abort

    for item in "${groups[@]}"; do
        if ! groups "$USER" | grep -q "$item"; then
            if ! sudo gpasswd -a "$USER" "$item"; then
                printf "%bFailed to add %s to %s!%b\n" "$RED" "$USER" "$item" "$RESET" >&2
                abort
            fi
            printf "%bAdded %s to %s successfully.%b\n" "$GREEN" "$USER" "$item" "$RESET"
        fi
    done
fi
