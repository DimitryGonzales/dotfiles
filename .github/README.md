# 🎨 Dotfiles

My personal dotfiles for an Arch Linux installation.

## 📦 Required dependencies

- `git`
- `sudo`

```
sudo pacman -S git sudo
```

## 🛠️ Instructions

### Cloning repository

📌 **Clone this repository and move its contents to your `home` directory:**

```
git clone "https://github.com/DimitryGonzales/dotfiles.git"
mv dotfiles/.* dotfiles/* ~
```

### Installing

📌 **Run the `setup.sh` script to do an automated installation of my Linux setup.**

```
cd ~
./setup.sh
```

*or*

ℹ️ **Run the `setup.sh` script with the `--essencial` flag to do a minimal installation.**

```
cd ~
./setup.sh --essencial
```

> It will only install essencial drivers and packages(the ones necessary for a fully functional system/automatically used by the system or with binds, e.g, spotify and spicetify are used in the theme.sh script, thunar is necessary for the bind SUPER+E to work).

### Changing themes

📌 **Run the `theme.sh` script to change the system theme.**

```
cd ~
./theme.sh
```

## VSCode

Install the matching color theme extension for your selected theme from the marketplace:

- [Catppuccin](https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc)

- [Github Theme](https://marketplace.visualstudio.com/items?itemName=GitHub.github-vscode-theme)

- [Gruvbox](https://marketplace.visualstudio.com/items?itemName=jdinhlife.gruvbox)

> ⚠️ Working in a way to install these automatically.

## 🖼️ Examples

**ℹ️ These images do not showcase all features/configurations.**

- Catppuccin Mocha Lavender

<table>
    <tr>
        <td><img src="./examples/catppuccin-mocha-lavender/catppuccin-mocha-lavender-1.png" alt="example-1"></td>
        <td><img src="./examples/catppuccin-mocha-lavender/catppuccin-mocha-lavender-2.png" alt="example-2"></td>
    </tr>
    <tr>
        <td><img src="./examples/catppuccin-mocha-lavender/catppuccin-mocha-lavender-3.png" alt="example-3"></td>
        <td><img src="./examples/catppuccin-mocha-lavender/catppuccin-mocha-lavender-4.png" alt="example-4"></td>
    </tr>
</table>

- Gruvbox Dark

<table>
    <tr>
        <td><img src="./examples/gruvbox-dark/gruvbox-dark-1.png" alt="example-1"></td>
        <td><img src="./examples/gruvbox-dark/gruvbox-dark-2.png" alt="example-2"></td>
    </tr>
    <tr>
        <td><img src="./examples/gruvbox-dark/gruvbox-dark-3.png" alt="example-3"></td>
        <td><img src="./examples/gruvbox-dark/gruvbox-dark-4.png" alt="example-4"></td>
    </tr>
</table>

- Minimalistic

<table>
    <tr>
        <td><img src="./examples/minimalistic/minimalistic-1.png" alt="example-1"></td>
        <td><img src="./examples/minimalistic/minimalistic-2.png" alt="example-2"></td>
    </tr>
    <tr>
        <td><img src="./examples/minimalistic/minimalistic-3.png" alt="example-3"></td>
        <td><img src="./examples/minimalistic/minimalistic-4.png" alt="example-4"></td>
    </tr>
</table>
