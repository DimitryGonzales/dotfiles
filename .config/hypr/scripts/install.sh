#!/usr/bin/env bash

# TODO
# Discord needs to be installed after vencord-hook to activate the trigger
# Steam needs to be executed at least one time before installing millennium

# Colors
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

confirm() {
    local confirm
    read -rp "$1 [Y/n] " confirm
    confirm="${confirm,,}"
    [[ "$confirm" == "n" ]] && abort
}

# Elevate privileges
sudo -v

# Check if multilib repository is enabled
if grep -q "#\[multilib\]" /etc/pacman.conf; then
    printf "%bMultilib repository is not enabled, uncomment it in /etc/pacman.conf!%b\n" "$RED" "$RESET" >&2
    abort
fi

# Update system
confirm "Update system?"
if ! sudo pacman -Syu --noconfirm; then
    printf "%bFailed to update system!%b\n" "$RED" "$RESET" >&2
    abort
fi
printf "%bUpdated system successfully.%b\n" "$GREEN" "$RESET"

# Install paru
if ! pacman -Q paru > /dev/null 2>&1; then
    printf "\n%bParu is not installed.%b\n" "$YELLOW" "$RESET"
    confirm "Install paru?"
    if ! (
        sudo pacman -S --needed --noconfirm base-devel git &&
        cd /tmp &&
        git clone "https://aur.archlinux.org/paru.git" &&
        cd paru &&
        makepkg -si --noconfirm &&
        cd ~
    ); then
        printf "%bFailed to install paru!%b\n" "$RED" "$RESET" >&2
        abort
    fi
    printf "%bParu installed successfully.%b\n" "$GREEN" "$RESET"
fi

# Install packages
PACKAGES=(
    # Driver: AMDGPU
    lib32-mesa
    lib32-vulkan-radeon
    mesa
    vulkan-radeon

    # Driver: audio
    lib32-pipewire
    lib32-pipewire-jack
    pipewire helvum pwvucontrol wireplumber
    pipewire-alsa
    pipewire-audio
    pipewire-jack
    pipewire-pulse

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

    # Software: Apps
    bitwarden
    brave-bin
    discord vencord-hook
    ente-auth-bin
    ghostty
    gparted
    localsend-bin
    lutris
    mission-center
    nautilus file-roller
    obs-studio
    pear-desktop-bin
    prismlauncher
    protonplus
    qbittorrent
    qimgv
    schildichat-desktop-bin
    speedcrunch
    steam #millennium
    telegram-desktop
    torbrowser-launcher
    ventoy-bin
    vlc vlc-plugins-all
    zed

    # Software: CLI
    bat
    chafa
    eza
    fastfetch
    ffmpeg
    fzf
    gallery-dl-bin
    imagemagick
    ncdu
    pfetch
    yt-dlp
    zsh oh-my-zsh-git zsh-autosuggestions zsh-pure-prompt zsh-syntax-highlighting

    # Software: system
    cliphist
    flatpak
    gamemode lib32-gamemode
    gnome-keyring libsecret
    icoextract
    ly
    mangohud goverlay lib32-mangohud
    matugen
    nodejs npm
    pacman-contrib reflector
    python
    rofi rofi-emoji
    swaync
    swww
    ufw
    waybar
    yadm

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
    darkly-bin frameworkintegration
    qt5-base
    qt5-wayland
    qt5ct-kde
    qt6-base
    qt6-wayland
    qt6ct-kde

    # XDG
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
)

printf "\n%bPackages:%b\n" "$BLUE" "$RESET"
packages_needed=false
for item in "${PACKAGES[@]}"; do
    if pacman -Q "$item" > /dev/null 2>&1; then
        printf "%b%s%b\n" "$GREEN" "$item" "$RESET"
    else
        printf "%b%s%b\n" "$YELLOW" "$item" "$RESET"
        packages_needed=true
    fi
done

if [[ "$packages_needed" = true ]]; then
    confirm "Install missing packages?"
    if ! paru -S --needed --noconfirm "${PACKAGES[@]}"; then
        printf "%bFailed to install all missing packages!%b\n" "$RED" "$RESET" >&2
        abort
    fi
    printf "%bInstalled all missing packages successfully.%b\n" "$GREEN" "$RESET"
fi

# Add user to groups
GROUPS=(
    gamemode
    input
    openrazer
    plugdev
)

printf "\n%bGroups:%b\n" "$BLUE" "$RESET"
groups_needed=false
for item in "${GROUPS[@]}"; do
    if groups "$USER" | grep -q "$item"; then
        printf "%b%s%b\n" "$GREEN" "$item" "$RESET"
    else
        printf "%b%s%b\n" "$YELLOW" "$item" "$RESET"
        groups_needed=true
    fi
done

if [[ "$groups_needed" == true ]]; then
    confirm "Add $USER to missing groups?"
    for item in "${GROUPS[@]}"; do
        if ! getent group "$item" > /dev/null; then
            printf "%b%s doesn't exist.%b\n" "$YELLOW" "$item" "$RESET"
            if ! sudo groupadd "$item" > /dev/null; then
                printf "%bFailed to create %s!%b\n" "$RED" "$item" "$RESET" >&2
                abort
            fi
            printf "%bCreated %s successfully.%b\n" "$GREEN" "$item" "$RESET"
        fi

        if ! groups "$USER" | grep -q "$item"; then
            if ! sudo gpasswd -a "$USER" "$item" > /dev/null; then
                printf "%bFailed to add %s to %s!%b\n" "$RED" "$USER" "$item" "$RESET" >&2
                abort
            fi
            printf "%bAdded %s to %s successfully.%b\n" "$GREEN" "$USER" "$item" "$RESET"
        fi
    done
fi

# Enable services
SERVICES=(
    paccache.timer
    systemd-oomd.service
    tor.service
    ufw.service
)

printf "\n%bServices:%b\n" "$BLUE" "$RESET"
services_needed=false
for item in "${SERVICES[@]}"; do
    if systemctl is-enabled "$item" > /dev/null; then
        printf "%b%s%b\n" "$GREEN" "$item" "$RESET"
    else
        printf "%b%s%b\n" "$YELLOW" "$item" "$RESET"
        services_needed=true
    fi
done

if [[ "$services_needed" == true ]]; then
    confirm "Enable disabled services?"
    for item in "${SERVICES[@]}"; do
        if ! systemctl is-enabled "$item" > /dev/null; then
            if ! sudo systemctl enable --now "$item" > /dev/null 2>&1; then
                printf "%bFailed to enable %s!%b\n" "$RED" "$item" "$RESET" >&2
                abort
            fi
            printf "%bEnabled %s successfully.%b\n" "$GREEN" "$item" "$RESET"
        fi
    done
fi

# Enable firewall
if sudo ufw status | grep -q "inactive"; then
    printf "\n%bFirewall(UFW) is not enabled.%b\n" "$YELLOW" "$RESET"
    confirm "Enable firewall(UFW)?"
    if ! sudo ufw enable > /dev/null; then
        printf "%bFailed to enable firewall(UFW)!%b\n" "$RED" "$RESET" >&2
        abort
    fi
    printf "%bEnabled firewall(UFW) successfully.%b\n" "$GREEN" "$RESET"
fi

# Clone dotfiles and apply theme
DOTFILES="https://github.com/DimitryGonzales/dotfiles.git"
printf "\n%bDotfiles:%b %s\n" "$BLUE" "$RESET" "$DOTFILES"
confirm "Clone dotfiles?"
if ! (
    yadm clone "$DOTFILES" &&
    yadm checkout --force
); then
    printf "%bFailed to clone dotfiles!%b\n" "$RED" "$RESET" >&2
    abort
fi
printf "%bCloned dotfiles successfully.%b\n" "$GREEN" "$RESET"

if ! ~/.config/hypr/scripts/theme.sh; then
    printf "%bFailed to apply theme!%b\n" "$RED" "$RESET" >&2
    abort
fi
printf "%bApplied theme successfully.%b\n" "$GREEN" "$RESET"

# Change default shell to ZSH
if [[ "$SHELL" != "$(command -v zsh)" ]]; then
    printf "\n%bZSH isn't the default shell.%b\n" "$YELLOW" "$RESET"
    confirm "Change default shell to ZSH?"
    if ! chsh -s "$(command -v zsh)" > /dev/null; then
        printf "%bFailed to change default shell to ZSH!%b\n" "$RED" "$RESET" >&2
        abort
    fi
    printf "%bChanged default shell to ZSH successfully.%b\n" "$GREEN" "$RESET"
fi

# Swap ly@tty1.service with getty@tty1.service
if ! systemctl status ly@tty1.service | grep -q "enabled"; then
    printf "\n%bly@tty1.service is disabled.%b\n" "$YELLOW" "$RESET"
    confirm "Swap ly@tty1.service with getty@tty1.service?"
    if ! (
        sudo systemctl enable ly@tty1.service &&
        sudo systemctl disable getty@tty1.service
    ) > /dev/null 2>&1; then
        printf "%bFailed to swap ly@tty1.service with getty@tty1.service!%b\n" "$RED" "$RESET" >&2
        abort
    fi
    printf "%bSwapped ly@tty1.service with getty@tty1.service successfully.%b\n" "$GREEN" "$RESET"
fi

printf "\n%bInstall script executed successfully.%b\n" "$GREEN" "$RESET"

# Reboot system
printf "\nIt's recommended to reboot the system to apply all changes.\n"
confirm "Reboot system?" && sleep 3
reboot
