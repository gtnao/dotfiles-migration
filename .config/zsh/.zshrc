HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY

# zinit
# https://github.com/zdharma-continuum/zinit?tab=readme-ov-file#manual
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

# prompt
zinit ice lucid from'gh-r' as'command' atclone'./starship init zsh > init.zsh; ./starship completions zsh > _starship' atpull'%atclone' src'init.zsh'
zinit light starship/starship

# neovim
zinit ice wait lucid from'gh-r' as'program' bpick'*tar.gz' pick'nvim*/bin/nvim' atclone'./nvim*/bin/nvim --headless "+Lazy! sync" +qa'
zinit light neovim/neovim

# asdf
zinit ice wait lucid from'gh-r' as'program' pick'asdf'
zinit light asdf-vm/asdf
