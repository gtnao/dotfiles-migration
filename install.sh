#!/bin/bash

set -eu

DOTFILES_HOME="${HOME}/dev/src/github.com/gtnao/dotfiles"

sudo apt update
sudo apt -y upgrade
sudo apt -y install git wget curl zip unzip build-essential

[ ! -d "${DOTFILES_HOME}" ] && mkdir -p "$(dirname "${DOTFILES_HOME}")"
[ ! -d "${DOTFILES_HOME}/.git" ] && git clone https://github.com/gtnao/dotfiles.git "${DOTFILES_HOME}"
"${DOTFILES_HOME}/deploy.sh"

sudo apt -y install zsh tmux
if command -v zsh >/dev/null 2>&1; then
	username="$(id -un)"
	zshpath="$(command -v zsh)"
	echo "Changing login shell for ${username} to ${zshpath}"
	sudo chsh -s "${username}" -s "${zshpath}"
fi
exec zsh -l
