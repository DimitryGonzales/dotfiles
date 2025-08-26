{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        hyprpolkitagent
        hyprpicker
        hyprshot
    ];

    programs = {
        # Hyprland
        hyprland = {
            enable = true;
            xwayland.enable = true;
        };

        # Hyprlock
        hyprlock.enable = true;
    };
}
