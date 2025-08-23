{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        polychromatic
    ];
    
    # OpenRazer
    hardware.openrazer = {
        enable = true;
        users = [
            "prlw"
        ];
    };
}
