{ ... }: {
    networking = {
        hostName = "nixos";

        # NetworkManager
        networkmanager.enable = true;
    };
}
