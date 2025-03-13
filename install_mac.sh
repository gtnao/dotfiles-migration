#!/bin/bash

set -eu

DOTFILES_HOME="${HOME}/dev/src/github.com/gtnao/dotfiles"

if ! xcode-select -p &>/dev/null 2>&1; then
	xcode-select --install
fi

[ ! -d "${DOTFILES_HOME}" ] && mkdir -p "$(dirname "${DOTFILES_HOME}")"
[ ! -d "${DOTFILES_HOME}/.git" ] && git clone https://github.com/gtnao/dotfiles-migration.git "${DOTFILES_HOME}"
"${DOTFILES_HOME}/deploy.sh"

if ! command -v brew &>/dev/null; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if ! grep -q '/opt/homebrew/bin/brew shellenv' "${HOME}/.zprofile"; then
	echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"${HOME}/.zprofile"
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew install tmux

exec zsh -l
