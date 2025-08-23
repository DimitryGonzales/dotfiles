{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        # GTK {
            gtk2
            gtk3
            gtk4
        # }

        # Qt {
            libsForQt5.qt5ct
            kdePackages.qt6ct
        # }

        # Apps {
            nwg-look
        # }

        # Icons {
            adwaita-icon-theme
            bibata-cursors
        # }

        # Themes {
            adw-gtk3
        # }
    ];
}
