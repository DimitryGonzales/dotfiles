# Change command executed by greetd
change_greetd_command() {
    local COMMAND="$1"

    copy "/etc/greetd/config.toml" "/etc/greetd/config.toml.bak"

    if sudo sed -i "s|^.*command *=.*|command = \"$COMMAND\"|" /etc/greetd/config.toml; then
        log "$SUCCESS Greetd command changed to: '$COMMAND'."
    else
        log "$ERROR Failed to change greetd command to: '$COMMAND'."
        return 1   
    fi

    return 0
}

# Execution
section "Desktop Manager"

change_greetd_command "tuigreet --cmd hyprland"
echo
