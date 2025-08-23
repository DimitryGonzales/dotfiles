{ ... }: {
    # Kernel Module
    boot.initrd.kernelModules = [ "amdgpu" ];

    # X11 Video Driver
    services.xserver.videoDrivers = [ "amdgpu" ];

    # Hardware Acceleration
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };
}
