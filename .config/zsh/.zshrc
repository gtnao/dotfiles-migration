# path
typeset -Ugx path
path=($HOME/.local/bin(N-/) $HOME/.asdf/shims(N-/) $path)

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

# key bindings
bindkey -e

function _fzf-ghq() {
  local selected_dir=$(ghq list -p | fzf)
  if [ -n "${selected_dir}" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N _fzf-ghq
bindkey '^]' _fzf-ghq

# completion
zstyle ':completion:*' menu select=2

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

# fzf
zinit ice wait lucid from'gh-r' as'program' pick'fzf' atclone'./fzf --zsh > shell-integration.zsh' atpull'%atclone' src"shell-integration.zsh"
zinit light junegunn/fzf

# ghq
zinit ice wait lucid from'gh-r' as'program' pick'ghq*/ghq'
zinit light x-motemen/ghq

# enhanced commands
zinit ice wait lucid from'gh-r' as'program' pick'bat*/bat'
zinit light sharkdp/bat
zinit ice wait lucid from'gh-r' as'program' pick'bottom*/btm'
zinit light ClementTsang/bottom
zinit ice wait lucid from'gh-r' as'program' pick'delta*/delta'
zinit light dandavison/delta
zinit ice wait lucid from'gh-r' as'program' pick'dust*/dust'
zinit light bootandy/dust
zinit ice wait lucid from'gh-r' as'program' pick'eza'
zinit light eza-community/eza
zinit ice wait lucid from'gh-r' as'program' pick'fd*/fd'
zinit light sharkdp/fd
zinit ice wait lucid from'gh-r' as'program' pick'procs'
zinit light dalance/procs
zinit ice wait lucid from'gh-r' as'program' pick'ripgrep*/rg'
zinit light BurntSushi/ripgrep
zinit ice wait lucid from'gh-r' as'program' mv'tealdeer* -> tldr'
zinit light tealdeer-rs/tealdeer
zinit ice wait lucid from'gh-r' as'program' pick'zoxide*/zoxide'
zinit light ajeetdsouza/zoxide

source "${ZDOTDIR}/rc/functions.zsh"

if command -v tmux >/dev/null 2>&1; then
	[ -z "$TMUX" ] && (tmux attach || tmux new-session)
fi
