{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        brave
        (discord.override {
            withVencord = true;
        })
        kitty
        mission-center
        qimgv
        rofi rofimoji rofi-power-menu
        spotify
        telegram-desktop
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
                thunar-archive-plugin # Provide file context menus for archives
                thunar-media-tags-plugin # Provide tagging and renaming features for media files
                thunar-vcs-plugin # Provide support for Subversion and Git
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
