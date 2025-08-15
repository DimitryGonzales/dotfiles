# Add user to group(s)
add_user_to_group() {
    local USERNAME="${SUDO_USER:-$USER}"

    for GROUP in "$@"; do
        if id -nG "$USERNAME" | grep -qw "$GROUP"; then
            log "$OK '$USERNAME' is already in group: '$GROUP'."
        else
            if sudo gpasswd -a "$USERNAME" "$GROUP"; then
                log "$SUCCESS '$USERNAME' added to group: '$GROUP'."
            else
                log "$ERROR Failed to add '$USERNAME' to group: '$GROUP'."
                return 1
            fi
        fi
    done

    return 0
}

# Groups
source "$SCRIPT_DIR/assets/groups/groups.sh"

# Execution
section "Groups"

add_user_to_group "${groups[@]}"
echo
