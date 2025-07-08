#!/usr/bin/env bash


# Setup #

## Abort at any error
set -e

## Flags
ESSENCIAL=false

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --essencial) 
            ESSENCIAL=true
            ;;
        *)
            log "[${YELLOW}ALERT${RESET}] Unknown option: $1"
            ;;
    esac
    shift
done

## Log function
if ! $ESSENCIAL; then
    log() {
        printf "[${MAGENTA}SCRIPT${RESET}] %b\n" "$*"
    }
else
    log() {
        printf "[${MAGENTA}SCRIPT${RESET}] [${YELLOW}ESSENCIAL${RESET}] %b\n" "$*"
    }
fi

## Fail message
trap "log '[${RED}FAIL${RESET}] Script execution failed. Exiting...'" ERR


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


# Functions #

## Add user to system groups
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

## Ask user to select an option
ask_user() {
    local num_options="$1"
    shift

    if (( $# != num_options * 2 )); then
        log "[${RED}ERROR${RESET}] Invalid arguments: expected $((num_options * 2)) option/command pairs, got $#."
        return 1
    fi

    log "Please choose an option:"
    for ((i=1; i<=num_options; i++)); do
        local idx=$(( (i - 1) * 2 + 1 ))
        local option_label="${!idx}"
        printf "  %d) %s\n" "$i" "$option_label"
    done

    while true; do
        read -rp "Enter choice [1-$num_options]: " choice

        if [[ "$choice" =~ ^[1-9][0-9]*$ ]] && (( choice >= 1 && choice <= num_options )); then
            local cmd_index=$(( (choice - 1) * 2 + 2 ))
            local cmd="${!cmd_index}"
            eval "$cmd"
            return 0
        else
            log "[${YELLOW}ALERT${RESET}] Invalid choice, try again."
        fi
    done
}

## Authenticate with sudo
authenticate() {
    if sudo -v; then
        log "[${GREEN}SUCCESS${RESET}] Successfully authenticated."
        return 0
    else
        log "[${RED}ERROR${RESET}] Failed to authenticate."
        return 1
    fi
}

## Change directory
change_directory() {
    local DIRECTORY="$1"

    if cd "$DIRECTORY"; then
        log "[${GREEN}SUCCESS${RESET}] Changed directory to: '$DIRECTORY'" 
        return 0
    else
        log "[${RED}ERROR${RESET}] Couldn't change directory to: '$DIRECTORY'"
        return 1
    fi
}

## Check package existence
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

## Copy directories/files
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

## Choose nvidia GPU family
choose_nvidia_family() {
    log "Detected GPUs in your computer:"

    lspci -k -d ::03xx

    log "Choose GPU Family (you can check https://nouveau.freedesktop.org/CodeNames.html for code name)":

    ask_user 2 \
        "Turing (NV160/TUXXX) and newer" "NVIDIA_FAMILY='1'" \
        "Maxwell (NV110/GMXXX) through Ada Lovelace (NV190/ADXXX)" "NVIDIA_FAMILY='2'"

    if NIVIDIA_FAMILY="1"; then
        nvidia_gpu_drivers=(
            ## Turing (NV160/TUXXX) and newer
            nvidia-open
        )
    elif NVIDIA_FAMILY="2"; then
        nvidia_gpu_drivers=(
            ## Maxwell (NV110/GMXXX) through Ada Lovelace (NV190/ADXXX)
            nvidia
        )
    fi
}

## Edit command executed by greetd
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

## Git clone repository
git_clone() {
    local URL="$1"

    if git clone "$URL"; then
        log "[${GREEN}SUCCESS${RESET}] Git cloned repository: '$URL'"
        return 0
    else
        log "[${RED}ERROR${RESET}] Failed to git clone repository: '$URL'"
        return 1
    fi
}

## Make directory
make_directory() {
    local DIRECTORY="$1"

    if [ -d "$DIRECTORY" ]; then
        log "[${BLUE}OK${RESET}] Directory already exists: '$DIRECTORY'"
        return 0
    else
        if sudo mkdir -p "$DIRECTORY"; then
            log "[${GREEN}SUCCESS${RESET}] Created directory: '$DIRECTORY'"
            return 0
        else
            log "[${RED}ERROR${RESET}] Failed to create directory: '$DIRECTORY'"
            return 1
        fi
    fi
}

## Make package
make_package() {
    log "Making package..."

    if makepkg -si; then
        log "[${GREEN}SUCCESS${RESET}] Successfully make package."
        return 0
    else
        log "[${RED}ERROR${RESET}] Failed to make package."
        return 1
    fi
}

## Install package with pacman
pacman_install() {
    if check_package "$@"; then
        log "[${BLUE}OK${RESET}] All packages are already installed."
        return 0
    else
        log "Installing missing packages..."

        if sudo pacman -S --needed "$@"; then
            log "[${GREEN}SUCCESS${RESET}] Successfully installed all packages."
            return 0
        else
            log "[${RED}ERROR${RESET}] Failed to install all packages."
            return 1
        fi
    fi
}

## Install package with paru
paru_install() {
    if check_package "$@"; then
        log "[${BLUE}OK${RESET}] All packages are already installed."
        return 0
    else
        log "Installing missing packages..."

        if paru -S --needed "$@"; then
            log "[${GREEN}SUCCESS${RESET}] Successfully installed all packages."
            return 0
        else
            log "[${RED}ERROR${RESET}] Failed to install all packages."
            return 1
        fi
    fi
}

## Enable service
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

## Start service
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


# GPU Drivers #

## AMD GPU drivers
amd_gpu_drivers=(
    ## Mesa (open source AMD driver)
    mesa 

    ### [Mesa] lib32 Mesa (32bit support for Mesa)
    lib32-mesa

    ### [Mesa] DDX Driver (provides 2D acceleration)
    xf86-video-amdgpu

    ### [Mesa] Vulkan (vulkan support)
    vulkan-radeon

    ### [Mesa] lib32 Vulkan (32bit support for Vulkan)
    lib32-vulkan-radeon
)

# NVIDIA GPU drivers are set on the choose_nvidia_family function


# Packages #

if ! $ESSENCIAL; then
## All from AUR
    aur_packages=(
        # Apps #

        ## Heroic Games Launcher {bin} (game launcher)
        heroic-games-launcher-bin

        ## JDownloader 2 (download manager)
        jdownloader2

        ## ProtonUP QT (proton manager)
        protonup-qt

        ## qimgv (media viewer)
        qimgv

        ### [Rofi] Rofi Power Menu (power menu)
        rofi-power-menu

        ## Visual Studio Code {bin} (IDE)
        visual-studio-code-bin

        ## WOEUsb NG (USB stick Windows installer creation tool)
        woeusb-ng

        ## Zen Browser {bin} (Firefox Fork Browser)
        zen-browser-bin


        # GTK #

        ## Catppucin GTK Theme Mocha (Catppuccin Mocha Themes)
        catppuccin-gtk-theme-mocha

        ## Gruvbox GTK Theme {git} (Gruvbox Themes)
        gruvbox-gtk-theme-git


        # Razer #

        ## Polychromatic (open source Razer configuration app)
        polychromatic


        # Tablet #
        
        ## OpenTabletDriver (open source tablet driver)
        opentabletdriver


        # Tools #

        ## Gallery DL (bulk download tool)
        gallery-dl

        ## OH MY BASH {git} (BASH customization and scripts)
        oh-my-bash-git

        ## Spicetify (Spicetify patcher for Spotify)
        spicetify-cli

        ### [Spicetify] Spicetify Marketplace {bin} (marketplace for spiceitfy)
        spicetify-marketplace-bin

        ## Vencord Hook (automatic Vencord patcher for Discord)
        vencord-hook
    )
else
## Essencials from AUR
    aur_packages=(
        ### [Rofi] Rofi Power Menu (power menu)
        rofi-power-menu

        ## Visual Studio Code {bin} (IDE)
        visual-studio-code-bin


        # GTK #

        ## Catppucin GTK Theme Mocha (Catppuccin Mocha Themes)
        catppuccin-gtk-theme-mocha

        ## Gruvbox GTK Theme {git} (Gruvbox Themes)
        gruvbox-gtk-theme-git


        # Tools #

        ## OH MY BASH {git} (BASH customization and scripts)
        oh-my-bash-git

        ## Spicetify (Spicetify patcher for Spotify)
        spicetify-cli

        ### [Spicetify] Spicetify Marketplace {bin} (marketplace for spiceitfy)
        spicetify-marketplace-bin

        ## Vencord Hook (automatic Vencord patcher for Discord)
        vencord-hook
    )
fi

if ! $ESSENCIAL; then
## All from official repositories
    pacman_packages=(
        # Apps #
        
        ## Discord (voice and text chat application)
        discord

        ## Firefox (browser)
        firefox

        ## Foot (not GPU accelerated terminal emulator)
        foot

        ### [Foot] Chafa (image to text converter)
        chafa

        ### [Foot] Fastfetch (system information fetch tool)
        fastfetch

        ### [Foot] NCDU (disk usage analyzer)
        ncdu

        ### [Foot] Speedtest (internet speed tester tool)
        speedtest-cli

        ### [Foot] Vim (terminal text editor)
        vim

        ### [Foot] [Vim] NeoVim (newer vim version)
        neovim

        ### [Foot] W3M (terminal website viewer)
        w3m

        ## GParted (partition manager)
        gparted

        ## GSmartControl (disk info viewer)
        gsmartcontrol

        ## Kitty (GPU accelerated terminal emulator)
        kitty

        ## LibreOffice (document editor)
        libreoffice-fresh

        ## Lutris (game launcher)
        lutris

        ## Mangohud (system statistics viewer)
        mangohud

        ### [Mangohud] Goverlay (Mangohud customization tool)
        goverlay

        ## Mission Center (process manager)
        mission-center

        ## OBS Studio (screen recorder)
        obs-studio

        ## QBittorrent (torrent client)
        qbittorrent

        ## Rofi (launcher)
        rofi

        ### [Rofi] Rofi Emoji (emoji selector)
        rofi-emoji

        ## Speedcrunch (calculator)
        speedcrunch

        ## Spotify (music app)
        spotify-launcher

        ## Steam (game launcher/store)
        steam

        ## SwayNC (notification center)
        swaync

        ## Thunar (file manager)
        thunar

        ### [Thunar] Catfish (file searcher)
        catfish

        ### [Thunar] File Roller (file archiver)
        file-roller

        ### [Thunar] GVFS (trash support, mounting with udisk and remote filesystems)
        gvfs

        ### [Thunar] [GVFS] GVFS MTP (allows you to manage phone files)
        gvfs-mtp

        ### [Thunar] Thunar Archive Plugin (archive creation and extraction)
        thunar-archive-plugin

        ### [Thunar] Thunar Media Tags Plugin (view/edit ID3/OGG tags)
        thunar-media-tags-plugin

        ### [Thunar] Thunar Volman (removable device management)
        thunar-volman

        ### [Thunar] Tumbler (thumbnail previews)
        tumbler

        ## VLC (media player)
        vlc

        ## Waybar (tool bar)
        waybar

        ## ZED (IDE)
        zed


        # Audio #

        ## Pipewire (low-level multimedia framework)
        pipewire

        ### [Pipewire] lib32 Pipewire (32bit support for Pipewire)
        lib32-pipewire

        ### [Pipewire] Pipewire Audio (use Pipewire as an audio server)
        pipewire-audio

        ### [Pipewire] Pipewire Alsa (route ALSA to Pipewire)
        pipewire-alsa

        ### [Pipewire] Pipewire Pulse (route PulseAudio to Pipewire)
        pipewire-pulse

        ### [Pipewire] Pipewire JACK (route JACK to Pipewire)
        pipewire-jack

        ### [Pipewire] lib32 Pipewire JACK (32bit support to route JACK to Pipewire)
        lib32-pipewire-jack

        ### [Pipewire] Wireplumber (session manager)
        wireplumber

        ### [Pipewire] Pavucontrol (audio input/output controller)
        pavucontrol

        ### [Pipewire] Helvum (audio sources controller)
        helvum

        
        # Fonts #

        ## Noto Fonts (basic)
        noto-fonts

        ### [Noto Fonts] Noto Fonts CJK (chinese, japanese and korean)
        noto-fonts-cjk

        ### [Noto Fonts] Noto Fonts Emoji (emojis)
        noto-fonts-emoji

        ### [Noto Fonts] Noto Fonts Extra (additional variants)
        noto-fonts-extra

        ## Font Awesome (icon library)
        ttf-font-awesome
        otf-font-awesome

        ## Liberation (Arial, Times New Roman, and Courier New)
        ttf-liberation

        ## JetBrains Mono (cool font)
        ttf-jetbrains-mono
        ttf-jetbrains-mono-nerd


        # Greeter #

        ## Greetd (greeter)
        greetd

        ### [Greetd] Tuigreet (theme for Greetd)
        greetd-tuigreet


        # GTK #

        ## Libraries
        gtk2
        gtk3
        gtk4

        ## Gnome Extra Themes (Adwaita)
        gnome-themes-extra

        ## NWG Look (GTK style manager)
        nwg-look


        # Linux #

        ## Linux Headers (needed by some packages e.g. Openrazer)
        linux-headers

        
        # Pacman #

        ## Contrib (clean cache)
        pacman-contrib

        ## Reflector (generate mirror list)
        reflector


        # QT #

        ## Libraries
        qt5ct
        qt5-wayland
        qt6ct
        qt6-wayland


        # Razer #

        ## Openrazer (open source Razer driver)
        openrazer-daemon


        # System #
        
        ## Hyprland (window manager)
        hyprland

        ### [Hyprland] Hyprpaper (wallpaper utility)
        hyprpaper

        ### [Hyprland] Hyprpicker (color picker)
        hyprpicker

        ### [Hyprland] Hyprlock (lockscreen utility)
        hyprlock

        ### [Hyprland] Hyprshot (screenshot utility)
        hyprshot

        ### [Hyprland] Hyprpolkitagent (polkit authentication daemon)
        hyprpolkitagent

        ### [Hyprland] Hyprcursor (cursor utility)
        hyprcursor

        ## XDG Desktop Portal (framework for securely accessing resources from outside an application sandbox)
        xdg-desktop-portal

        ### [XDG Desktop Portal] XDG Desktop Portal Hyprland (handles most of operations)
        xdg-desktop-portal-hyprland

        ### [XDG Desktop Portal] XDG Desktop Portal GTK (handles the operations Hyprland portal can't)
        xdg-desktop-portal-gtk


        # Tools #

        ## BTRFS progs (BTRFS utilities)
        btrfs-progs

        ## Cliphist (clipboard)
        cliphist

        ## Gamemode (daemon that optimizes OS for gaming)
        gamemode

        ### [Gamemode] lib32 Gamemode (32bit support for Gamemode)
        lib32-gamemode

        ## Inetutils (net utilities)
        inetutils

        ## NTFS (ntfs utilities)
        ntfs-3g

        ## UFW (firewall)
        ufw
    )
else
## Essencials from official repositories
    pacman_packages=(
        # Apps #
        
        ## Discord (voice and text chat application)
        discord

        ## Foot (not GPU accelerated terminal emulator)
        foot

        ### [Foot] Chafa (image to text converter)
        chafa

        ### [Foot] Fastfetch (system information fetch tool)
        fastfetch

        ## Kitty (GPU accelerated terminal emulator)
        kitty

        ## Mission Center (process manager)
        mission-center

        ## Rofi (launcher)
        rofi

        ### [Rofi] Rofi Emoji (emoji selector)
        rofi-emoji

        ## Spotify (music app)
        spotify-launcher

        ## SwayNC (notification center)
        swaync

        ## Thunar (file manager)
        thunar

        ### [Thunar] Catfish (file searcher)
        catfish

        ### [Thunar] File Roller (file archiver)
        file-roller

        ### [Thunar] GVFS (trash support, mounting with udisk and remote filesystems)
        gvfs

        ### [Thunar] [GVFS] GVFS MTP (allows you to manage phone files)
        gvfs-mtp

        ### [Thunar] Thunar Archive Plugin (archive creation and extraction)
        thunar-archive-plugin

        ### [Thunar] Thunar Media Tags Plugin (view/edit ID3/OGG tags)
        thunar-media-tags-plugin

        ### [Thunar] Thunar Volman (removable device management)
        thunar-volman

        ### [Thunar] Tumbler (thumbnail previews)
        tumbler

        ## Waybar (tool bar)
        waybar


        # Audio #

        ## Pipewire (low-level multimedia framework)
        pipewire

        ### [Pipewire] lib32 Pipewire (32bit support for Pipewire)
        lib32-pipewire

        ### [Pipewire] Pipewire Audio (use Pipewire as an audio server)
        pipewire-audio

        ### [Pipewire] Pipewire Alsa (route ALSA to Pipewire)
        pipewire-alsa

        ### [Pipewire] Pipewire Pulse (route PulseAudio to Pipewire)
        pipewire-pulse

        ### [Pipewire] Pipewire JACK (route JACK to Pipewire)
        pipewire-jack

        ### [Pipewire] lib32 Pipewire JACK (32bit support to route JACK to Pipewire)
        lib32-pipewire-jack

        ### [Pipewire] Wireplumber (session manager)
        wireplumber

        ### [Pipewire] Pavucontrol (audio input/output controller)
        pavucontrol

        
        # Fonts #

        ## Noto Fonts (basic)
        noto-fonts

        ### [Noto Fonts] Noto Fonts CJK (chinese, japanese and korean)
        noto-fonts-cjk

        ### [Noto Fonts] Noto Fonts Emoji (emojis)
        noto-fonts-emoji

        ### [Noto Fonts] Noto Fonts Extra (additional variants)
        noto-fonts-extra

        ## Font Awesome (icon library)
        ttf-font-awesome
        otf-font-awesome

        ## Liberation (Arial, Times New Roman, and Courier New)
        ttf-liberation

        ## JetBrains Mono (cool font)
        ttf-jetbrains-mono
        ttf-jetbrains-mono-nerd


        # Greeter #

        ## Greetd (greeter)
        greetd

        ### [Greetd] Tuigreet (theme for Greetd)
        greetd-tuigreet


        # GTK #

        ## Libraries
        gtk2
        gtk3
        gtk4

        ## Gnome Extra Themes (Adwaita)
        gnome-themes-extra

        ## NWG Look (GTK style manager)
        nwg-look


        # Linux #

        ## Linux Headers (needed by some packages e.g. Openrazer)
        linux-headers

        
        # Pacman #

        ## Contrib (clean cache)
        pacman-contrib

        ## Reflector (generate mirror list)
        reflector


        # QT #

        ## Libraries
        qt5ct
        qt5-wayland
        qt6ct
        qt6-wayland


        # System #
        
        ## Hyprland (window manager)
        hyprland

        ### [Hyprland] Hyprpaper (wallpaper utility)
        hyprpaper

        ### [Hyprland] Hyprpicker (color picker)
        hyprpicker

        ### [Hyprland] Hyprlock (lockscreen utility)
        hyprlock

        ### [Hyprland] Hyprshot (screenshot utility)
        hyprshot

        ### [Hyprland] Hyprpolkitagent (polkit authentication daemon)
        hyprpolkitagent

        ## XDG Desktop Portal (framework for securely accessing resources from outside an application sandbox)
        xdg-desktop-portal

        ### [XDG Desktop Portal] XDG Desktop Portal Hyprland (handles most of operations)
        xdg-desktop-portal-hyprland

        ### [XDG Desktop Portal] XDG Desktop Portal GTK (handles the operations Hyprland portal can't)
        xdg-desktop-portal-gtk


        # Tools #

        ## Cliphist (clipboard)
        cliphist

        ## Inetutils (net utilities)
        inetutils

        ## UFW (firewall)
        ufw
    )
fi


# Execution #

## Essencial flag message
if $ESSENCIAL; then
    log "[${YELLOW}ALERT${RESET}] The script will run with the 'ESSENCIAL' flag activated. It will only install essencial drivers and packages(the ones necessary for a fully functional system/automatically used by the system or with binds, e.g, spotify and spicetify are used in the theme.sh script, thunar is necessary for the bind SUPER+E to work)."
    echo
fi

## Authenticate user
log "[Authentication]\n"
if authenticate; then
    clear
    (sudo -v; while true; do sleep 60; sudo -n true; done) &
    SUDO_REFRESH_PID=$!
    trap 'kill $SUDO_REFRESH_PID 2>/dev/null' EXIT
else
    echo
    exit 1
fi

## Go to home directory
change_directory "$HOME"
echo

## Install paru
log "[${CYAN}Paru${RESET}]"

if ! check_package "paru"; then
    pacman_install "base-devel"
    git_clone "https://aur.archlinux.org/paru.git"
    change_directory "paru"
    make_package
    change_directory "$HOME"
fi
echo

## Install GPU drivers
log "[${CYAN}GPU Drivers${RESET}]"

log "Which drivers do you want?"
    
ask_user 2 \
    "AMD" "pacman_install \${amd_gpu_drivers[*]}" \
    "NVIDIA" "choose_nvidia_family && pacman_install \${nvidia_gpu_drivers[*]}"
echo

## Install packages
### Official repositories
log "[${CYAN}Pacman Packages${RESET}]"
pacman_install "${pacman_packages[@]}"
echo

### AUR
log "[${CYAN}AUR Packages${RESET}]"
paru_install "${aur_packages[@]}"
echo

### Install/Reinstall discord (triggers Vencord Hook)
log "[${CYAN}Vencord${RESET}]"

log "Do you want to install/reinstall Discord? (Vencord Hook will automatically patch it with Vencord)"

ask_user 2 \
    "Yes" "log '[${BLUE}OK${RESET}] Installing/Reinstalling Discord... Vencord Hook will patch it with Vencord at the end.' && echo && sudo pacman -S --noconfirm discord && echo" \
    "No" "log '[${BLUE}OK${RESET}] Skipping Discord installation/reinstallation... You can install/reinstall it at any time and Vencord Hook will automatically patch it with Vencord.'"
echo

## Services
### Enable greetd
log "[${CYAN}Greetd${RESET}]"
edit_greetd_command "tuigreet --cmd hyprland"
system_enable "greetd"
echo

### Add user to groups
log "[${CYAN}Groups${RESET}]"
add_user_to_group "input" "gamemode" "plugdev"
echo

### Enable and start paccache
log "[${CYAN}Paccache${RESET}]"
system_enable "paccache.timer"
system_start "paccache.timer"
echo

### Enable and start systemd-oomd
log "[${CYAN}Systemd OOMD${RESET}]"
system_enable "systemd-oomd"
system_start "systemd-oomd"
echo

### Enable and start ufw
log "[${CYAN}UFW${RESET}]"
system_enable "ufw"
system_start "ufw"
echo


# End #

## Success Message
log "[${GREEN}SUCCESS${RESET}] Script executed with success."
echo

## Ask user if he wants to reboot
log "[${CYAN}Reboot${RESET}]"

log "Do you want to reboot?"

ask_user 2 \
    "Yes" "log '[${BLUE}OK${RESET}] Rebooting...' && sleep 3 && reboot" \
    "No" "log '[${BLUE}OK${RESET}] It is recommended to reboot! Exiting...' && exit 0"
