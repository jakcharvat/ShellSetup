# ------------------------------ Powerlevel10k ------------------------------
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

BREW_DIR=""
if [[ $(uname -s) == "Darwin" ]]
then
    BREW_DIR="/usr/local"
else
    BREW_DIR="/home/linuxbrew/.linuxbrew"
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
fi
source "${BREW_DIR}/opt/powerlevel10k/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Custom propt, overriden by Powerlevel10k
# PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{250}%1~%f%b %# '


# ------------------------------ Google Cloud SDK ------------------------------
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jakcharvat/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jakcharvat/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jakcharvat/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jakcharvat/google-cloud-sdk/completion.zsh.inc'; fi

export PATH=/Users/jakcharvat/dev/material_motion/tools/contributor_tools/mdm/bin:$PATH


# ------------------------------ Flutter SDK ------------------------------
export PATH="$PATH:/Users/jakcharvat/flutter/bin"


# ------------------------------ Arcanist ------------------------------
export PATH="$PATH:/Users/jakcharvat/.arc/arcanist/bin"


# ------------------------------ Coolc ------------------------------
export PATH="$PATH:/Users/jakcharvat/dev/compilers/coolc"


# ------------------------------ Autocomplete and Syntax Highlighting ------------------------------
source "${BREW_DIR}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "${BREW_DIR}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'
# ZSH_AUTOSUGGEST_STRATEGY=(completion history)


# ------------------------------ Node ------------------------------
export PATH="${BREW_DIR}/Cellar/node/15.10.0_1/bin:$PATH"


# ------------------------------ FZF ------------------------------
[ -f "$(dirname $0)/.fzf.zsh" ] && source "$(dirname $0)/.fzf.zsh"
export FZF_DEFAULT_OPTS='--height=60% --preview="bat --style="header" --color=always --line-range=:500 {}" --preview-window=right:60%:wrap'
export FZF_DEFAULT_COMMAND='fd --exclude node_modules'
export FZF_CTRL_T_COMMAND='fd --exclude node_modules'
export FZF_ALT_C_COMMAND='fd --exclude node_modules'


# ------------------------------ Mongo ------------------------------
alias mongo-start="brew services start mongodb-community"
alias mongo-restart="brew services restart mongodb-community"
alias mongo-stop="brew services stop mongodb-community"


# ------------------------------ Helper Functions ------------------------------
mkcdir() {
    mkdir -p -- "$1" &&
    cd -P -- "$1"
}

gccgas() {
    gcc -fno-asynchronous-unwind-tables -fno-exceptions -fno-rtti -fverbose-asm -Wall -Wextra "$1.c" -O3 -masm=intel -S -o "$1.s"
}

ctonasm() {
    BASE="${1%.*}"
    gcc -fno-asynchronous-unwind-tables -fno-exceptions -fno-rtti -fverbose-asm -Wall -Wextra "$BASE.c" -O3 -masm=intel -o "$BASE.obj"
    objconv -fnasm "$BASE.obj"
    sed -i '' -e 's/align=1//g' -e 's/[a-z]*execute//g' -e 's/: *function//g' -e '/default *rel/d' "$BASE.asm"
    rm "$BASE.obj"
}

vimf() {
  vim $(find "$1" -type f | fzf)
}

DIRNAME="$(dirname $0)"
create-gitignore() {
  cp "${DIRNAME}/default.gitignore" ./.gitignore
}

create-ccls-config () {
  cp "${DIRNAME}/.ccls.template" ./.ccls
}


get_abs_filename() {
  # $1 : relative filename
  echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}


# ------------------------------ Aliases ------------------------------
alias pwh="pwd | sed \"s|^$HOME|~|\""
alias lgit='lazygit'
alias lg="lazygit"


# replacing ls with exa
alias ls='exa --color=automatic --group-directories-first --icons'
alias la='ls -al'
alias ll='ls -l'
alias lr='exa --colour=never'
alias lsc='ls --color=always'
alias lac='la --color=always'
alias llc='la --color=always'
alias lsdir="ll -D"


# ssh
alias sftp='sftp -F ~/.ssh/config'
alias scp='scp -F ~/.ssh/config'


alias comp='g++-11 -Wall -pedantic'


hash -d d="/Users/jakcharvat/dev"
hash -d pa="/Users/jakcharvat/FIT/PA1"
hash -d eforce="/Users/jakcharvat/FIT/eForce"
hash -d dock="/Users/jakcharvat/docker"

setopt AUTO_CD


# ------------------------------ Makefile Autocomplete ------------------------------
zstyle ':completion:*:*:make:*' tag-order 'targets'
autoload -U compinit && compinit


# ------------------------------ Golang ------------------------------
#export GOROOT=/usr/local/Cellar/go/1.16.3/libexec
#export GOPATH=/Users/jakcharvat/go
#export PATH=$PATH:$GOROOT/bin:$GOPATH/bin


# ------------------------------ Spaceship ------------------------------
# # Set Spaceship ZSH as a prompt
# autoload -U promptinit; promptinit
# prompt spaceship
#
#
# # ORDER
# SPACESHIP_PROMPT_ORDER=(
#   time     #
#   vi_mode  # these sections will be
#   user     # before prompt char
#   host     #
#   char
#   dir
#   git
#   node
#   ruby
#   xcode
#   swift
#   golang
#   docker
#   venv
#   pyenv
# )
#
#
#
#
# To customize prompt, run `p10k configure` or edit ~/p10k-starship.zsh.
[[ ! -f $(dirname $0)/p10k-starship.zsh ]] || source $(dirname $0)/p10k-starship.zsh


# alias gcc=gcc-11
# alias g++=g++-11


# ------------------------------ GIT Aliases ------------------------------
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.pl pull
git config --global alias.ps push


lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

EDITOR='nvim'
