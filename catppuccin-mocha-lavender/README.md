# Catppuccin Mocha Lavender

A configuration setup based on the [Catppuccin](https://catppuccin.com/palette/) **Mocha** color palette, using **Lavender** as the accent color.

---

## Screenshots

> ⚠️ *These screenshots do not showcase all features/configurations.*

![example-1](/source/examples/catppuccin-mocha-lavender/catppuccin-mocha-lavender-1.png)
![example-2](/source/examples/catppuccin-mocha-lavender/catppuccin-mocha-lavender-2.png)  
![example-3](/source/examples/catppuccin-mocha-lavender/catppuccin-mocha-lavender-3.png)
![example-4](/source/examples/catppuccin-mocha-lavender/catppuccin-mocha-lavender-4.png)

---

# Instructions

## Required Dependencies (for full functionality)

- [Cliphist](https://github.com/sentriz/cliphist)  
- [Font Awesome](https://github.com/FortAwesome/Font-Awesome)  
- [Foot](https://codeberg.org/dnkl/foot)
- [GTK Catppuccin](https://github.com/catppuccin/gtk)
- [Hyprland](https://github.com/hyprwm/Hyprland)  
- [Hyprlock](https://github.com/hyprwm/hyprlock)  
- [Hyprpicker](https://github.com/hyprwm/hyprpicker)  
- [Hyprshot](https://github.com/Gustash/Hyprshot)  
- [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono)  
- [Kitty](https://github.com/kovidgoyal/kitty)  
- [Mission Center](https://github.com/Slimbook-Team/mission-center)  
- [Neofetch](https://github.com/dylanaraps/neofetch)  
- [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)
- [NWG Look](https://github.com/nwg-piotr/nwg-look)
- [Rofi](https://github.com/davatorium/rofi)  
- [Rofi-Emoji](https://github.com/Mange/rofi-emoji)  
- [Rofi Power Menu](https://github.com/jluttine/rofi-power-menu)  
- [Spicetify](https://github.com/spicetify/cli)  
- [Spicetify Marketplace](https://github.com/spicetify/marketplace)  
- [SwayNC](https://github.com/ErikReider/SwayNotificationCenter)  
- [Thunar](https://docs.xfce.org/xfce/thunar/start)  
- [Vesktop](https://github.com/Vencord/Vesktop)  
- [Waybar](https://github.com/Alexays/Waybar)  
- [zsh](https://github.com/zsh-users/zsh)  
- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)  

## For Arch Linux Users

### Install all packages from both repositories:

#### Official Repositories (using `pacman`):

```bash
sudo pacman -S --needed cliphist ttf-font-awesome otf-font-awesome foot hyprland hyprlock hyprpicker nwg-look ttf-jetbrains-mono kitty mission-center neofetch nerd-fonts rofi rofi-emoji swaync thunar waybar zsh
```

#### AUR (using `yay` or `paru`):
> 📌 You can use either yay or paru depending on which AUR helper you have installed.

```bash
yay -S --needed catppuccin-gtk-theme-mocha hyprshot oh-my-zsh-git rofi-power-menu spicetify-cli spicetify-marketplace-bin vesktop-bin
```
_or_
```bash
paru -S --needed catppuccin-gtk-theme-mocha hyprshot oh-my-zsh-git rofi-power-menu spicetify-cli spicetify-marketplace-bin vesktop-bin
```

---

## After Installing Dependencies

> 📌 Only replace files that match those in the repository. Do not replace entire folders unless explicitly instructed (e.g., for Hyprland).

### Foot (Terminal)

1. Copy `dotfiles/.config/foot` to `~/.config/`.
2. Set `zsh` as the default shell (`sudo chsh -s $(which zsh) $USER`).
3. Copy `dotfiles/.zshrc` to your home directory (`~/`).
4. Copy `dotfiles/.oh-my-zsh` to your home directory (`~/`).

### GTK Theme

1. Open **nwg-look (GTK Settings)** and choose:  
   `catppuccin-mocha-lavender-standard+default`

### Hyprland (Window Manager)

1. Delete `~/.config/hypr` and replace it with `dotfiles/.config/hypr`.

### Kitty (Terminal)

1. Run `kitten themes` and select **Catppuccin-Mocha**, or manually copy `dotfiles/.config/kitty` to `~/.config/`.
2. Set `zsh` as the default shell (`sudo chsh -s $(which zsh) $USER`). *(Skip if already done in [Foot setup](#foot-terminal))*
3. Copy `dotfiles/.zshrc` to your home directory (`~/`) *(Skip if done in [Foot setup](#foot-terminal))* and update the last line: replace `--chafa` with `--kitty`.
4. Copy `dotfiles/.oh-my-zsh` to your home directory (`~/`). *(Skip if done in [Foot setup](#foot-terminal))*

### Neofetch

1. Copy `dotfiles/.config/neofetch` to `~/.config/`.

### Rofi

1. Copy `dotfiles/.config/rofi` to `~/.config/`.

### Spotify

1. Follow the [official Spicetify setup guide](https://spicetify.app/docs/getting-started). _(`spicetify-cli` should already be installed from the [dependency step](#required-dependencies-for-full-functionality))_
2. Follow the [official Marketplace setup guide](https://spicetify.app/docs/getting-started). _(`spicetify-marketplace-bin` should already be installed from the [dependency step](#required-dependencies-for-full-functionality))_
3. In Spotify, go to `Marketplace > Themes` and install **Catppuccin**.
4. Go to `Settings` and change the accent color to **Lavender**.

### SwayNC

1. Copy `dotfiles/.config/swaync` to `~/.config/`.

### Vesktop

1. Copy `dotfiles/.config/vesktop` to `~/.config/`.
2. Inside Vesktop, go to `User Settings > Themes` and enable **Catppuccin Mocha**.

### Waybar

> 📌 Remember to add your user to the `input` group (required for full functionality of waybar).

1. Copy `dotfiles/.config/waybar` to `~/.config/`.

---
