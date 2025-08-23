{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        cliphist wl-clipboard
        matugen
        swaynotificationcenter
        swww
        yadm
    ];

    programs = {
        # Bash
        bash = {
            completion = {
                enable = true;
                package = pkgs.bash-completion;
            };

            enableLsColors = true;

            shellAliases = {
                cp="cp --verbose -r";
                mkdir="mkdir -p";

                ls = "ls -lh --color=auto";
                lsa = "ls -lah --color=auto";

                nr = "sudo nixos-rebuild";
                nrs = "sudo nixos-rebuild switch";
                nrsu = "sudo nixos-rebuild switch --upgrade";
                ncg = "sudo nix-collect-garbage -d";

                sw = "matugen -v image";
            };
        };

        # File-Roller (archive manager, needed by thunar-archive-plugin)
        file-roller.enable = true;

        # Git
        git = {
            enable = true;
            config.init.defaultBranch = "main";
        };

        # Waybar
        waybar.enable = true;

        # Xfconf (needed to save xfce apps configs)
        xfconf.enable = true;
    };

    services = {
        # GVFS (mount, trash, and other functionalities)
        gvfs.enable = true;

        # Tumbler (needed for thumbnail support for images)
        tumbler.enable = true;
    };
}
