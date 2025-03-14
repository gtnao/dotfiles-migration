#!/bin/bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "${HOME}/.config"
ln -sfn "${SCRIPT_DIR}/.config/git" "${HOME}/.config/git"
ln -sfn "${SCRIPT_DIR}/.config/nvim" "${HOME}/.config/nvim"
ln -sfn "${SCRIPT_DIR}/.config/tmux" "${HOME}/.config/tmux"
ln -sfn "${SCRIPT_DIR}/.config/wezterm" "${HOME}/.config/wezterm"
ln -sfn "${SCRIPT_DIR}/.config/zsh" "${HOME}/.config/zsh"
ln -sfn "${SCRIPT_DIR}/.config/zsh/.zshenv" "${HOME}/.zshenv"
