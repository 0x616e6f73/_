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

# Function to start Zellij with current date as session name
zj() {
  ZELLIJ_SESSION_NAME=$(date '+%Y-%m-%d') zellij "$@"
}

# Alias for quick access
alias zellij='zj'
