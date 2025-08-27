{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        brave
        kitty
        mission-center
        qimgv
        rofi rofimoji rofi-power-menu
        spotify
        telegram-desktop
        vesktop
        vlc
        waypaper
    ];

    programs = {
        # Firefox
        firefox.enable = true;

        # Thunar
        thunar = {
            enable = true;

            plugins = with pkgs.xfce; [
                thunar-archive-plugin # File context menus for archives
                thunar-media-tags-plugin # Tagging and renaming features for media files
                thunar-vcs-plugin # Support for Subversion and Git
                thunar-volman # Automatic management of removable drives and media
            ];
        };

        # VSCode
        vscode = {
            enable = true;
                
            extensions = with pkgs.vscode-extensions; [
                bbenoist.nix
                github.github-vscode-theme
                leonardssh.vscord
                pkief.material-icon-theme
                ritwickdey.liveserver
            ];
        };
    };
}
