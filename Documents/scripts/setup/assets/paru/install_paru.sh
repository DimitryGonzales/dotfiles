# Execution
section "Paru"

if ! check_package "paru"; then
    git_clone "https://aur.archlinux.org/paru.git"
    change_directory "paru"
    make_package
    change_directory ".."
    remove_directory "paru"
fi
echo
