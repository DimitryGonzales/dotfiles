# Choose NVIDIA GPU family
choose_nvidia_family() {
    log "Detected GPUs in your computer:"

    lspci -k -d ::03xx

    log "Choose GPU Family (you can check https://nouveau.freedesktop.org/CodeNames.html for code name):"

    ask_user 2 \
        "Turing (NV160/TUXXX) and newer" "NVIDIA_FAMILY='1'" \
        "Maxwell (NV110/GMXXX) through Ada Lovelace (NV190/ADXXX)" "NVIDIA_FAMILY='2'"

    if NIVIDIA_FAMILY="1"; then
        nvidia_gpu_drivers=(
            ## Turing (NV160/TUXXX) and newer
            nvidia-open
        )
    elif NVIDIA_FAMILY="2"; then
        nvidia_gpu_drivers=(
            ## Maxwell (NV110/GMXXX) through Ada Lovelace (NV190/ADXXX)
            nvidia
        )
    fi
}

# AMD GPU Drivers
source "$SCRIPT_DIR/gpu_drivers/amd_gpu_drivers.sh"

# Execution
section "GPU Drivers"

log "Which drivers do you want?"
    
ask_user 2 \
    "AMD" "pacman_install \${amd_gpu_drivers[*]}" \
    "NVIDIA" "choose_nvidia_family && pacman_install \${nvidia_gpu_drivers[*]}"
echo
