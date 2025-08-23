{ pkgs, ... }: {
    users.users = {
        prlw = {
            isNormalUser = true;
            description = "prlw";
            extraGroups = [ "gamemode" "networkmanager" "wheel" ];
            shell = pkgs.bash;
        };
    };
}
