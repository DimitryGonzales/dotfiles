# Enable service
only_enable_service() {
    for SERVICE in "$@"; do
        if systemctl is-enabled --quiet "$@"; then
            log "$OK Service is already enabled: '$SERVICE'."
        else
            if systemctl enable "$SERVICE"; then
                log "$SUCCESS Enabled service: '$SERVICE'."
            else
                log "$ERROR Failed to enable service: '$SERVICE'."
                return 1
            fi
        fi
    done

    return 0
}

## Enable and start service
enable_and_start_service() {
    for SERVICE in "$@"; do
        if systemctl is-active --quiet "$@"; then
            log "$OK Service is already started: '$SERVICE'."
        else
            if systemctl enable --now "$SERVICE"; then
                log "$SUCCESS Enabled and started service: '$SERVICE'."
            else
                log "$ERROR Failed to enable and start service: '$SERVICE'."
                return 1
            fi
        fi
    done

    return 0
}

# Services
source "$SCRIPT_DIR/services/services.sh"

# Execution
section "Services"
only_enable_service "${only_enable_services[@]}"
enable_and_start_service "${enable_and_start_services[@]}"
echo
