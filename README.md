# Dotfiles

---

# Instructions

## Required Dependencies (for full functionality)

- [Chafa](https://github.com/hpjansson/chafa)
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
- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
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

## For Arch Linux Users

### Install all packages from both repositories:

#### Official Repositories (using `pacman`):

```bash
sudo pacman -S --needed chafa cliphist ttf-font-awesome otf-font-awesome foot hyprland hyprlock hyprpicker ttf-jetbrains-mono kitty mission-center neofetch nerd-fonts nwg-look rofi rofi-emoji swaync thunar waybar zsh
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

📌 **Copy everything inside `files` to your `HOME` folder**.

️ℹ️ **Apply/Change theme with `theme.sh` script**

### Spotify

1. Follow the [official Spicetify setup guide](https://spicetify.app/docs/getting-started). _(`spicetify-cli` should already be installed from the [dependency step](#required-dependencies-for-full-functionality))_
2. Follow the [official Marketplace setup guide](https://spicetify.app/docs/getting-started). _(`spicetify-marketplace-bin` should already be installed from the [dependency step](#required-dependencies-for-full-functionality))_
3. In Spotify, go to `Marketplace > Themes` and install the respective theme.
4. Go to `Settings` and change the accent color to the corresponding one for your theme.

### VSCode

Install the corresponding colors extension for your theme.

### Waybar

Inside `~/.config/waybar/config.jsonc`, locate both Waybar configurations (one for each monitor) and change the **output** field in each section to match your respective monitors. If you only have one monitor, update the **output** value in the section corresponding to that monitor. This determines which monitor each Waybar appears on. If you are on hyprland, check monitors names with:

```bash
hyprctl monitors
```

---

## Examples

> ⚠️ *These images do not showcase all features/configurations.*

# Catppuccin Mocha Lavender

![example-1](/source/examples/catppuccin-mocha-lavender/catppuccin-mocha-lavender-1.png)
![example-2](/source/examples/catppuccin-mocha-lavender/catppuccin-mocha-lavender-2.png)  
![example-3](/source/examples/catppuccin-mocha-lavender/catppuccin-mocha-lavender-3.png)
![example-4](/source/examples/catppuccin-mocha-lavender/catppuccin-mocha-lavender-4.png)

---