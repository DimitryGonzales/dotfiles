#!/usr/bin/env bash

# Abort at any error
set -e

## Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Base functions
source "$SCRIPT_DIR/assets/base/base.sh"

# Execution
clear

## Authentication
authenticate
echo

## Go to home directory
change_directory "$HOME"
echo

## Paru
source "$SCRIPT_DIR/assets/paru/install_paru.sh"

## GPU Drivers
source "$SCRIPT_DIR/assets/gpu_drivers/install_gpu_drivers.sh"

## Packages
source "$SCRIPT_DIR/assets/packages/install_packages.sh"

## Groups
source "$SCRIPT_DIR/assets/groups/add_user_to_groups.sh"

## Services
source "$SCRIPT_DIR/assets/services/enable_and_start_services.sh"

## Desktop Manager
source "$SCRIPT_DIR/assets/desktop_manager/setup_desktop_manager.sh"

## Reboot
section "Reboot"

log "Do you want to reboot?"

ask_user 2 \
    "Yes" "reboot" \
    "No" "log '$ALERT A reboot is recommended to apply all settings.'"

## Success
log "$SUCCESS Script executed without errors."
