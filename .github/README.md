# Dotfiles

My personal dotfiles for an Arch Linux installation, including configurations for Hyprland, themes, and keybindings.

## 📝 TODO

### setup.sh

- Automatically install Spicetify themes.
- Automatically install VSCode themes.

## 📦 Required dependencies

- `git`
- `sudo`

```bash
sudo pacman -S git sudo
```

## 📜 Instructions

### 📂 Cloning repository

📌 **Clone this repository and copy the necessary files to your `home` folder:**

```bash
cd ~
git clone "https://github.com/DimitryGonzales/dotfiles.git"
cp -r dotfiles/.config ~ && cp -r dotfiles/sources ~ && cp -r dotfiles/.bashrc ~
```

> ℹ️ Customize the files to suit your personal preferences (e.g., editing the Hyprland config file to adjust monitor settings).

> 🚨 After running git pull in the repository, remember to manually copy any new or updated files to avoid overwriting your custom changes.

### ⚙️ Installing

📌 **Run the `setup.sh` script to do an automated installation of my Linux setup:**

```bash
cd ~/dotfiles
./setup.sh
```

*or*

📌 **Run the `setup.sh` script with the `--essential` flag to do a minimal installation:**

```bash
cd ~/dotfiles
./setup.sh --essential
```

> ℹ️ This will install only essential drivers and packages, those required for a functional system and tools automatically used by scripts or keybindings (e.g., Spotify and Spicetify are used in theme.sh; Thunar is required for the SUPER+E bind).

### 🎨 Changing themes

📌 **Run the `theme.sh` script to change the system theme.**

```bash
cd ~/dotfiles
./theme.sh
```

## 💻 VSCode

📌 **Install the matching color theme extension for your selected theme:**

- [Catppuccin](https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc)

- [Github Theme](https://marketplace.visualstudio.com/items?itemName=GitHub.github-vscode-theme)

- [Gruvbox](https://marketplace.visualstudio.com/items?itemName=jdinhlife.gruvbox)

> 🛠️ I'm working on automating the installation of these extensions.

## 🖼️ Examples

> ℹ️ These screenshots do not showcase all features or configurations.

### 🌙 Catppuccin Mocha Lavender

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

### 🟤 Gruvbox Dark

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

### 🧼 Minimalistic

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
