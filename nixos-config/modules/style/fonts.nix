{ pkgs, ... }: {
    fonts.packages = with pkgs; [
        font-awesome
        inter
        jetbrains-mono nerd-fonts.jetbrains-mono
        liberation_ttf
        noto-fonts noto-fonts-cjk-sans noto-fonts-color-emoji
    ];
}
