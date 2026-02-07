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
    printf "%b\nExecution aborted!%b\n" "$RED" "$RESET" >&2
    exit 1
}

# Update system
printf "%bUpdating system...%b\n" "$YELLOW" "$RESET"
if ! sudo pacman -Syu --noconfirm; then
    printf "%bFailed to update system!%b\n" "$RED" "$RESET" >&2
    abort
fi
printf "%bUpdated system successfully.%b\n" "$GREEN" "$RESET"

# Check and install paru
if ! pacman -Q paru > /dev/null 2>&1; then
    printf "%b\nparu isn't installed, installing...%b\n" "$YELLOW" "$RESET"

    if ! (
        sudo pacman -S --needed --noconfirm base-devel git &&
        cd /tmp &&
        git clone "https://aur.archlinux.org/paru.git" &&
        cd paru &&
        makepkg -si &&
        cd ~
    ) > /dev/null; then
        printf "%bFailed to install paru!%b\n" "$RED" "$RESET" >&2
        abort
    fi
    printf "%bparu installed successfully.%b\n" "$GREEN" "$RESET"
fi

# Check and install packages
packages=(
    # Driver: AMDGPU
    lib32-mesa
    lib32-vulkan-radeon
    mesa
    vulkan-radeon

    # Driver: mouse(Razer)
    openrazer-daemon linux-headers
    polychromatic

    # Driver: tablet
    opentabletdriver

    # Hyprland
    hyprland
    hyprlock
    hyprpicker
    hyprpolkitagent
    hyprshot

    # Pipewire
    lib32-pipewire
    lib32-pipewire-jack
    pipewire helvum pavucontrol wireplumber
    pipewire-alsa
    pipewire-audio
    pipewire-jack
    pipewire-pulse

    # Software: CLI
    bat
    chafa
    cliphist
    eza
    fastfetch
    ffmpeg
    flatpak
    fzf
    gamemode lib32-gamemode
    gallery-dl-bin
    gnome-keyring libsecret
    icoextract
    imagemagick
    ly
    mangohud goverlay lib32-mangohud
    matugen
    ncdu
    nodejs npm
    pacman-contrib reflector
    pfetch
    python
    swww
    ufw
    yadm
    yt-dlp
    zsh oh-my-zsh-git zsh-autosuggestions zsh-pure-prompt zsh-syntax-highlighting

    # Software: GUI
    bitwarden
    brave-bin
    discord vencord-hook
    ente-auth-bin
    ghostty
    gparted
    heroic-games-launcher-bin
    localsend-bin
    lutris
    mission-center
    nautilus file-roller
    obs-studio
    pear-desktop-bin
    prismlauncher
    protonplus
    qimgv
    rofi rofi-emoji
    schildichat-desktop-bin
    speedcrunch
    steam millennium
    swaync
    telegram-desktop
    torbrowser-launcher
    ventoy-bin
    vlc vlc-plugins-all
    waybar
    zed

    # Style: cursor
    bibata-cursor-theme-bin

    # Style: font
    inter-font
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    otf-font-awesome
    ttf-jetbrains-mono
    ttf-jetbrains-mono-nerd
    ttf-nerd-fonts-symbols

    # Style: GTK
    adw-gtk-theme
    adwaita-icon-theme
    gtk3
    gtk4

    # Style: Qt
    darkly-bin
    qt5-base
    qt5-wayland
    qt5ct
    qt6-base
    qt6-wayland
    qt6ct

    # XDG
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
)

printf "\n%bPackages:%b\n" "$BLUE" "$RESET"
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
    read -rp "Install missing packages? [Y/n] " packages_confirm
    packages_confirm="${packages_confirm,,}"
    [[ "$packages_confirm" == "n" ]] && abort

    if ! paru -S --needed --noconfirm "${packages[@]}"; then
        printf "%bFailed to install all missing packages!%b\n" "$RED" "$RESET" >&2
        abort
    fi
    printf "%bInstalled all missing packages successfully.%b\n" "$GREEN" "$RESET"
fi

# Add user to groups
groups=(
    gamemode
    input
    openrazer
    plugdev
)

printf "\n%bGroups:%b\n" "$BLUE" "$RESET"
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
    read -rp "Add "$USER" to missing groups? [Y/n] " groups_confirm
    groups_confirm="${groups_confirm,,}"
    [[ "$groups_confirm" == "n" ]] && abort

    for item in "${groups[@]}"; do
        if ! groups "$USER" | grep -q "$item"; then
            if ! sudo gpasswd -a "$USER" "$item" > /dev/null; then
                printf "%bFailed to add %s to %s!%b\n" "$RED" "$USER" "$item" "$RESET" >&2
                abort
            fi
            printf "%bAdded %s to %s successfully.%b\n" "$GREEN" "$USER" "$item" "$RESET"
        fi
    done
fi

# Check and enable/disable services
services=(
    paccache.timer
    systemd-oomd.service
    tor.service
    ufw.service
)

printf "\n%bServices:%b\n" "$BLUE" "$RESET"
services_needed=false
for item in "${services[@]}"; do
    if systemctl is-enabled "$item" > /dev/null; then
        printf "%b%s%b\n" "$GREEN" "$item" "$RESET"
    else
        printf "%b%s%b\n" "$YELLOW" "$item" "$RESET"
        services_needed=true
    fi
done

if [[ "$services_needed" == true ]]; then
    read -rp "Enable disabled services? [Y/n] " services_confirm
    services_confirm="${services_confirm,,}"
    [[ "$services_confirm" == "n" ]] && abort

    for item in "${services[@]}"; do
        if ! systemctl is-enabled "$item" > /dev/null; then
            if ! sudo systemctl enable --now "$item" > /dev/null; then
                printf "%bFailed to enable %s!%b\n" "$RED" "$item" "$RESET" >&2
                abort
            fi
            printf "%bEnabled %s successfully.%b\n" "$GREEN" "$item" "$RESET"
        fi
    done
fi

abort

# Clone dotfiles
printf "%b\nCloning dotfiles...%b\n" "$YELLOW" "$RESET"
if ! (
    yadm clone "https://github.com/DimitryGonzales/dotfiles.git" &&
    yadm checkout --force
) > /dev/null; then
    printf "%bFailed to clone dotfiles!%b\n" "$RED" "$RESET" >&2
    abort
fi
printf "%bCloned dotfiles successfully.%b\n" "$GREEN" "$RESET"

# Select theme
printf "%b\nSelecting theme...%b\n" "$YELLOW" "$RESET"
if ! ~/.config/hypr/scripts/theme.sh; then
    printf "%bFailed to apply theme!%b\n" "$RED" "$RESET" >&2
    abort
fi
printf "%bApplied theme successfully.%b\n" "$GREEN" "$RESET"

# Swap ly@tty1.service with disable getty@tty1.service
if ! systemctl status ly@tty1.service | grep -iq "enabled"; then
    printf "%b\nly@tty1.service is disabled, swapping with getty@tty1.service...%b\n" "$YELLOW" "$RESET"

    if ! (
        sudo systemctl enable ly@tty1.service &&
        sudo systemctl disable getty@tty1.service
    ) > /dev/null; then
        printf "%bFailed to swap ly@tty1.service with getty@tty1.service!%b\n" "$RED" "$RESET" >&2
        abort
    fi
    printf "%bSwapped ly@tty1.service with getty@tty1.service successfully.%b\n" "$GREEN" "$RESET"
fi

printf "%b\nInstall script executed successfully.\n%b" "$GREEN" "$RESET"

# Prompt to restart system
read -rp "Restart system?(recommended) [Y/n] " restart_confirm
restart_confirm="${restart_confirm,,}"
[[ "$restart_confirm" == "n" ]] && exit 0
reboot
