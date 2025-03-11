#!/bin/bash

set -eu

DOTFILES_HOME="${HOME}/dev/src/github.com/gtnao/dotfiles"

if ! xcode-select -p &>/dev/null 2>&1; then
	xcode-select --install
fi

[ ! -d "${DOTFILES_HOME}" ] && mkdir -p "$(dirname "${DOTFILES_HOME}")"
[ ! -d "${DOTFILES_HOME}/.git" ] && git clone https://github.com/gtnao/dotfiles-migration.git "${DOTFILES_HOME}"
"${DOTFILES_HOME}/deploy.sh"

exec zsh -l
