{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        # Games {
            osu-lazer-bin
        # }

        # Launchers {
            heroic
            lutris
            prismlauncher
        # }

        # MangoHud {
            mangohud
            goverlay
        # }

        # Proton {
            protonup-qt
        # }
    ];

    # OpenTabletDriver
    hardware.opentabletdriver.enable = true;

    programs = {
        # Gamemode
        gamemode.enable = true;

        # Steam
        steam = {
            enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
        };
    };
}
