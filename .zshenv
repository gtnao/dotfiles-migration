# XDG
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_CACHE_HOME="${HOME}/.cache"

# zsh
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# path
typeset -Ugx path
path=(
  $HOME/.asdf/shims(N-/)
  $path
)

# Rust
[[ -f "${HOME}/.cargo/env" ]] && . "${HOME}/.cargo/env"

# SDKMAN!
[[ -f "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && . "${HOME}/.sdkman/bin/sdkman-init.sh"
