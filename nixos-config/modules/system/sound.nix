{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        helvum
        pavucontrol
    ];

    # Rtkit
    security.rtkit.enable = true;

    services = {
        # Pipewire
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
        };

        # Disable Pulseaudio
        pulseaudio.enable = false;
    };
}
