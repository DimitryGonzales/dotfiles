{ pkgs, ... }: {
    boot = {
        loader = {
            efi.canTouchEfiVariables = true;
            timeout = 60;
            
            systemd-boot = {
                enable = true;
                editor = false;
                consoleMode = "max";
            };
        };

        # Kernel
        kernelPackages = pkgs.linuxPackages_latest;
    };
}
