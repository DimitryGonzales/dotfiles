# Packages
source "$SCRIPT_DIR/assets/packages/official_packages.sh"
source "$SCRIPT_DIR/assets/packages/aur_packages.sh"

# Execution
section "Packages"
pacman_install "${official_packages[@]}"
paru_install "${aur_packages[@]}"
echo

section "Vencord"

log "Do you want to install/reinstall Discord? (Vencord Hook will automatically patch it with Vencord)"

ask_user 2 \
    "Yes" "log '$OK Installing/Reinstalling Discord... Vencord Hook will patch it with Vencord at the end of the process.' && echo && sudo pacman -S --noconfirm discord && echo" \
    "No" "log '$OK Skipping Discord installation/reinstallation... You can install/reinstall it at any time and, if present, Vencord Hook will automatically patch it with Vencord.'"
echo
