# check if wezterm is available before trying to use cli
function hx() {
    if command -v wezterm &> /dev/null; then
        wezterm cli set-user-var IS_HELIX true
        command hx "$@"
        wezterm cli set-user-var IS_HELIX false
    else
        command hx "$@"
    fi
}
