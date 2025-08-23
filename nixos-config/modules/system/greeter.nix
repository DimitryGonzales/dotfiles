{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        tuigreet
    ];

    # Greetd
    services.greetd = {
        enable = true;
        settings = {
            default_session = {
                command = "${pkgs.tuigreet}/bin/tuigreet --cmd hyprland";
                user = "greeter";
            };
        };
    };
}
