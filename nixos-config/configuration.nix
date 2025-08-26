{ config, pkgs, ... }: {
    imports = [ 
        ./hardware-configuration.nix # Results of the hardware scan.

        # Pkgs & Programs {
            ./modules/software/apps.nix
            ./modules/software/hyprland.nix
            ./modules/software/tools.nix
        # }

        # Style {
            ./modules/style/assets.nix
            ./modules/style/fonts.nix
        # }

        # System {
            ./modules/system/amdgpu.nix
            ./modules/system/boot.nix
            ./modules/system/gaming.nix
            ./modules/system/greeter.nix
            ./modules/system/input.nix
            ./modules/system/locale.nix
            ./modules/system/networking.nix
            ./modules/system/sound.nix
            ./modules/system/users.nix
            ./modules/system/x11.nix
        # }
    ];

    # Allow Unfree Pkgs
    nixpkgs.config.allowUnfree = true;

    # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken. It‘s perfectly fine and recommended to leave this value at the release version of the first install of this system. Before changing this value read the documentation for this option (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.05"; # Did you read the comment?
}
